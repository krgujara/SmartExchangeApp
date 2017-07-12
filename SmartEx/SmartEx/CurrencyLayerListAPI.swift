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

struct CurrencyLayerAPI
{
    private static let baseUrlString = "http://apilayer.net/api/list"
    private static let APIKey = "1f0ccacc0da56cc5a48c860d8c6107b8"
    var URL : NSURL
    
    
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
    
    static func currenciesFromJSONData(data: NSData) -> CurrencyLayerAPIResults{
        
        do{
            if let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: []){
                if let jsonDictionary = jsonObject as? [String:AnyObject]{
                    // print("JSON DICTIONARY:  \(jsonDictionary)")
                    
                    if let currencies = jsonDictionary["currencies"] as? [String: String] {
                        var finalCurrecies = [Currency]()
                        //finalCurrecies.append(Currency(currencyCode: "AUS",fullCurrencyName: "AUSSSS"))
                        for (key, value) in currencies{
                            let currency = Currency(currencyCode: key,fullCurrencyName: value)
                            finalCurrecies.append(currency)
                        }
                        if finalCurrecies.count == 0 && currencies.count > 0{
                            //we werent able to parse any ofthe photos
                            //May be the json format of photos has changed
                            return .Failure(CurrencyLayerError.InvalidJSONData)
                        }
                        //print("Currencies::  \(currencies)")
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