//
//  HistoricalDataStore.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/23/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

class HistoricalDataStore
{
    var store = [HistoricalData]()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)}()
    
    
    func fetchHistoricalData(baseCurrency: String, toCurrency :String, date : String, completion : (HistoricalDataAPIResults)->Void) {
        let url = HistoricalDataAPI.historicalDataURL(date)
        //print("URL: \(url)")
        let request = NSURLRequest(URL: url)
        //let finalCurrencies
        let task = session.dataTaskWithRequest(request){
            (data, response, error)->Void in
            let result = self.processHistoricalData(baseCurrency, toCurrency :toCurrency, date: date ,data: data, error: error)
            
            completion(result)
            
        }
        task.resume()
        
    }
    
    init(){
        // getAllCurrencies()
        // fetchListOfCurrencies()
        
    }
    func getAllCurrencies()
    {
        for _ in 0..<5 {
           // getCurrency()
        }
    }
    
    func processHistoricalData(baseCurrency: String, toCurrency :String, date: String, data : NSData?, error : NSError?) -> HistoricalDataAPIResults{
        guard let jsonData = data else{
            return .Failure(error!)
        }
        return HistoricalDataAPI.historicalDataFromJSONData(baseCurrency, toCurrency: toCurrency, date: date, data: jsonData)
    }
}
