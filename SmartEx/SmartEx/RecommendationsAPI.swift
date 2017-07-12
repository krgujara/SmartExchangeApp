//
//  RecommendationsAPI.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/26/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation
enum RecommendationsAPIResults{
    case Success([Recommendations])
    case Failure(ErrorType)
}

enum RecommendationsDataError: ErrorType{
    case InvalidJSONData
}

struct RecommendationsDataAPI
{
    private static let baseUrlString = "http://apilayer.net/api/historical"
    private static let APIKey = "36eaaf74e346f2c8a65c26179fc3d301"
    var URL : NSURL
    
    //returns the URL for accessing data for any given date
    static func RecommendationURL(date: String) -> NSURL {
        let components = NSURLComponents(string: baseUrlString)!
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [ "access_key":APIKey,
                           "date": date ]
        
        for (key, value) in baseParams{
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        components.queryItems = queryItems
        return components.URL!
    }
    
    //queries the web server for the data in the JSON format. returns an enum type with success or failure
    static func RecommendationsDataFromJSONData(baseCurrency: String, toCurrency: String, date: String, data: NSData) -> RecommendationsAPIResults{
        
        do{
            if let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: []){
                if let jsonDictionary = jsonObject as? [String:AnyObject]{
                    
                    
                    
                    
                    if let quotes = jsonDictionary["quotes"] as? [String: Double] {
                        var finalRecommendations = [Recommendations]()
                        
                        for (key, value) in quotes{
                            
                            let recommendationData = Recommendations(currency: key, rate: value)
                            finalRecommendations.append(recommendationData)
                        }
                        if finalRecommendations.count == 0 && quotes.count > 0{
                            
                            return .Failure(RecommendationsDataError.InvalidJSONData)
                        }
                        
                        return .Success(finalRecommendations)
                    }else{
                        return .Failure(RecommendationsDataError.InvalidJSONData)
                    }
                    
                    
                }else{
                    print("Cannot create json dictionary")
                    return .Failure(RecommendationsDataError.InvalidJSONData)
                }
            }else{
                return .Failure(RecommendationsDataError.InvalidJSONData)
            }
            
        }
        catch let error{
            return .Failure(error)
        }
        
    }
}