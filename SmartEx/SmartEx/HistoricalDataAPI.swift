//
//  HistoricalDataAPI.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/23/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

enum HistoricalDataAPIResults{
    case Success(HistoricalData)
    case Failure(ErrorType)
}

enum HistoricalDataError: ErrorType{
    case InvalidJSONData
}

struct HistoricalDataAPI
{
    private static let baseUrlString = "http://apilayer.net/api/historical"
    private static let APIKey = "1f0ccacc0da56cc5a48c860d8c6107b8"
    var URL : NSURL
    
    
    static func historicalDataURL(date: String) -> NSURL {
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
    
    static func historicalDataFromJSONData(baseCurrency: String, toCurrency: String, date: String, data: NSData) -> HistoricalDataAPIResults{
        //print("Inside Historical Data FromJSON: \(baseCurrency)")
        //print("Inside Historical Data From JSON: \(toCurrency)")
        do{
            if let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: []){
                if let jsonDictionary = jsonObject as? [String:AnyObject]{
                    // print("JSON DICTIONARY:  \(jsonDictionary)")
                    
                    if let quotes = jsonDictionary["quotes"] as? [String: Int], let USDToBaseCurrencyRate = quotes["USDRUB"],let USDToToCurrency = quotes["USDINR"]{
                             //print("BASE RATE: \(USDToBaseCurrencyRate)")
                        //print("To Currency: \(USDToToCurrency)")
                        
                        let rate = (Double)((Double)(USDToToCurrency)/(Double)(USDToBaseCurrencyRate))
                        //print("Rate: \(rate)")
                        let historicalDataForOneDate = HistoricalData(baseCurrency: baseCurrency, toCurrency: toCurrency, date: date, rate: rate)

                        return .Success(historicalDataForOneDate)
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