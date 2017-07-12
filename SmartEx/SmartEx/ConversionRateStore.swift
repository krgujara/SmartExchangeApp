//
//  ConversionRateStore.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

class ConversionRateStore
{
    var conversionStore = [ConversionRate]()
    var store = [ConversionRate]()
    
    //generates a default configuration session
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)}()
    
    //fetches conversion rates with USD as base currency
    func fetchListOfConversionRates(completion completion : (LiveCurrencyLayerAPIResults)->Void) {
        let url = LiveCurrencyLayerAPI.liveCurrencyLayerURL()
        let request = NSURLRequest(URL: url)
        //let finalCurrencies
        let task = session.dataTaskWithRequest(request){
            (data, response, error)->Void in
            
            let result = self.processCurrencyList(data: data, error: error)
            completion(result)
        }
        task.resume()
        
        
    }
    // this function gets internally called by the fetchListOfConversionRates()
    func processCurrencyList(data data : NSData?, error : NSError?) -> LiveCurrencyLayerAPIResults{
        guard let jsonData = data else{
            return .Failure(error!)
        }
        return LiveCurrencyLayerAPI.liveCurrenciesFromJSONData(jsonData)
    }
    
   
      }
