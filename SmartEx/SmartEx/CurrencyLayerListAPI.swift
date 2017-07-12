//
//  CurrencyLayerListAPI.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/20/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//


import Foundation

enum CurrencyLayerAPIResults{
    case Success([Currency])
    case Failure(ErrorType)
}

enum CurrencyLayerError: ErrorType{
    case InvalidJSONData
}
//Struct which has information of API Key and important parameters required
struct CurrencyLayerAPI
{
    private static let baseUrlString = "http://apilayer.net/api/list"
    private static let APIKey = "36eaaf74e346f2c8a65c26179fc3d301"
    var URL : NSURL
    
 //this func generates the required URL
    static func currencyLayerURL()-> NSURL{
        let components = NSURLComponents(string: baseUrlString)!
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = ["access_key":APIKey]
        
        for (key, value) in baseParams{
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        components.queryItems = queryItems
        return components.URL!
    }
    
    //this func queries the currenclylayer webserver for the list of currencies that it supports. result will be either fenum type of ailure or success- 3 letter currency codes for countries
    static func currenciesFromJSONData(data: NSData) -> CurrencyLayerAPIResults{
        
        do{
            if let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: []){
                if let jsonDictionary = jsonObject as? [String:AnyObject]{
                    
                    if let currencies = jsonDictionary["currencies"] as? [String: String] {
                        var finalCurrecies = [Currency]()
                        for (key, value) in currencies{
                            let currency = Currency(currencyCode: key,fullCurrencyName: value)
                            finalCurrecies.append(currency)
                        }
                        if finalCurrecies.count == 0 && currencies.count > 0{
                            
                            return .Failure(CurrencyLayerError.InvalidJSONData)
                        }
                        return .Success(finalCurrecies)
                    }else{
                        return .Failure(CurrencyLayerError.InvalidJSONData)
                    }
                    
                }else{
                    print("Cannot create json dictionary")
                    return .Failure(CurrencyLayerError.InvalidJSONData)
                }
            }else{
                return .Failure(CurrencyLayerError.InvalidJSONData)
            }
            
        }
        catch let error{
            return .Failure(error)
        }
        
    }
}