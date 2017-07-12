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
    private static let APIKey = "36eaaf74e346f2c8a65c26179fc3d301"
    var URL : NSURL
    
    //generates URL for fetching historical data
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
    
    //fetches the historical data from the server. this function is being called by the controller
    
    static func historicalDataFromJSONData(baseCurrency: String, toCurrency: String, date: String, data: NSData) -> HistoricalDataAPIResults{
        
        do{
            if let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: []){
                if let jsonDictionary = jsonObject as? [String:AnyObject]{
                    
                    
                    if let quotes = jsonDictionary["quotes"] as? [String: Int], let USDToBaseCurrencyRate = quotes[baseCurrency],let USDToToCurrency = quotes[toCurrency]{
                        
                        
                        let rate = (Double)((Double)(USDToToCurrency)/(Double)(USDToBaseCurrencyRate))
                        
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