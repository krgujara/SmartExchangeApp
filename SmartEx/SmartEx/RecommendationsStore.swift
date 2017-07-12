//
//  RecommendationsStore.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/26/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit

class RecommendationsStore
{
    var store = [Recommendations]()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)}()
    
    
     func fetchHistoricalDataForRecommendations(baseCurrency: String, toCurrency :String, date : String, completion : (RecommendationsAPIResults)->Void) {
        let url = RecommendationsDataAPI.RecommendationURL(date)
     //let url = RecommendationsAPI.historicalDataURL(date)
     //print("URL: \(url)")
     let request = NSURLRequest(URL: url)
     //let finalCurrencies
     let task = session.dataTaskWithRequest(request){
     (data, response, error)->Void in
     let result = self.processRecommendationsData(baseCurrency, toCurrency :toCurrency, date: date ,data: data, error: error)
     
     completion(result)
     
     }
     task.resume()
     
     }
    
    init(){
        // getAllCurrencies()
        // fetchListOfCurrencies()
        
    }
    
       func processRecommendationsData(baseCurrency: String, toCurrency :String, date: String, data : NSData?, error : NSError?) -> RecommendationsAPIResults{
     guard let jsonData = data else{
     return .Failure(error!)
     }
        return RecommendationsDataAPI.RecommendationsDataFromJSONData(baseCurrency, toCurrency: toCurrency, date:date, data: jsonData)
     }
}
