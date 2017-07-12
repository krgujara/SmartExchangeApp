//
//  CurrencyLayerLiveAPI.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/21/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation
enum LiveCurrencyLayerAPIResults{
    case Success([ConversionRate])
    case Failure(ErrorType)
}

enum LiveCurrencyLayerError: ErrorType{
    case InvalidJSONData
}

struct LiveCurrencyLayerAPI
{
    private static let baseUrlString = "http://apilayer.net/api/live"
    private static let APIKey = "1f0ccacc0da56cc5a48c860d8c6107b8"
    var URL : NSURL
    
    
    static func liveCurrencyLayerURL()-> NSURL{
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
    
    static func liveCurrenciesFromJSONData(data: NSData) -> LiveCurrencyLayerAPIResults{
        
        do{
            if let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: []){
                if let jsonDictionary = jsonObject as? [String:AnyObject]{
                    // print("JSON DICTIONARY:  \(jsonDictionary)")
                    
                    if let quotes = jsonDictionary["quotes"] as? [String: Int] {
                        var finalConversionRates = [ConversionRate]()
                        //finalCurrecies.append(Currency(currencyCode: "AUS",fullCurrencyName: "AUSSSS"))
                        for (key, value) in quotes{
                            //let currency = Currency(currencyCode: key,fullCurrencyName: value)
                            let conversionRate = ConversionRate(toCurrency: key, rate: value)
                            finalConversionRates.append(conversionRate)
                        }
                        if finalConversionRates.count == 0 && quotes.count > 0{
                            //we werent able to parse any ofthe photos
                            //May be the json format of photos has changed
                            return .Failure(CurrencyLayerError.InvalidJSONData)
                        }
                        //print("Currencies::  \(currencies)")
                        return .Success(finalConversionRates)
                    }else{
                        return .Failure(CurrencyLayerError.InvalidJSONData)
                    }
                    
                }else{
                    print("Cannot create json dictionary for conversion rates")
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