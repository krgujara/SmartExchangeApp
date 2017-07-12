//
//  CurrencyStore.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/5/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

//Currency Store has information of all currencies we fetch from web

class CurrencyStore
{
    var store = [Currency]()
    
    //generates a default configuration session
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)}()
    
    //fetches the list of currencies that are supported by the currencylayer API
    func fetchListOfCurrencies(completion completion : (CurrencyLayerAPIResults)->Void) {
        let url = CurrencyLayerAPI.currencyLayerURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request){
            (data, response, error)->Void in
            
            let result = self.processCurrencyList(data: data, error: error)
            
            completion(result)
            
        }
        task.resume()
        
    }
    
    init(){
        
    }
    //this function gets internally called by the fetchListOfCurrencies(). Processes Currency list from the information we download from the web server
    func processCurrencyList(data data : NSData?, error : NSError?) -> CurrencyLayerAPIResults{
        guard let jsonData = data else{
            return .Failure(error!)
        }
        return CurrencyLayerAPI.currenciesFromJSONData(jsonData)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
