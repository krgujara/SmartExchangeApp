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
    private static let APIKey = "1f0ccacc0da56cc5a48c860d8c6107b8"
    var URL : NSURL
    
    
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
    
    static func RecommendationsDataFromJSONData(baseCurrency: String, toCurrency: String, date: String, data: NSData) -> RecommendationsAPIResults{
        //print("Inside Historical Data FromJSON: \(baseCurrency)")
        //print("Inside Historical Data From JSON: \(toCurrency)")
        do{
            if let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: []){
                if let jsonDictionary = jsonObject as? [String:AnyObject]{
                    // print("JSON DICTIONARY:  \(jsonDictionary)")
                    
                    //, let USDToBaseCurrencyRate = quotes[baseCurrency],let USDToToCurrency = quotes[toCurrency]
                    
                    
                    
                    if let quotes = jsonDictionary["quotes"] as? [String: Int] {
                        var finalRecommendations = [Recommendations]()
                        //finalCurrecies.append(Currency(currencyCode: "AUS",fullCurrencyName: "AUSSSS"))
                        for (key, value) in quotes{
                            //let currency = Currency(currencyCode: key,fullCurrencyName: value)
                            let recommendationData = Recommendations(currency: key, rate: value)
                            finalRecommendations.append(recommendationData)
                        }
                        if finalRecommendations.count == 0 && quotes.count > 0{
                            //we werent able to parse any ofthe photos
                            //May be the json format of photos has changed
                            return .Failure(RecommendationsDataError.InvalidJSONData)
                        }
                        //print("Currencies::  \(currencies)")
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