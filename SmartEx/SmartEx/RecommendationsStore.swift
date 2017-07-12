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
    
    //returns historical data for the given date
     func fetchHistoricalDataForRecommendations(baseCurrency: String, toCurrency :String, date : String, completion : (RecommendationsAPIResults)->Void) {
        let url = RecommendationsDataAPI.RecommendationURL(date)
     
     let request = NSURLRequest(URL: url)
     
     let task = session.dataTaskWithRequest(request){
     (data, response, error)->Void in
     let result = self.processRecommendationsData(baseCurrency, toCurrency :toCurrency, date: date ,data: data, error: error)
     
     completion(result)
     
     }
     task.resume()
     
     }
    
    
    // parses the JSON data by calling a function defined  in the API file.
       func processRecommendationsData(baseCurrency: String, toCurrency :String, date: String, data : NSData?, error : NSError?) -> RecommendationsAPIResults{
     guard let jsonData = data else{
     return .Failure(error!)
     }
        return RecommendationsDataAPI.RecommendationsDataFromJSONData(baseCurrency, toCurrency: toCurrency, date:date, data: jsonData)
     }
}
