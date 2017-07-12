//
//  CurrencyStore.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/5/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

class CurrencyStore
{
    var store = [Currency]()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)}()
    
 
    func fetchListOfCurrencies(completion completion : (CurrencyLayerAPIResults)->Void) {
        let url = CurrencyLayerAPI.currencyLayerURL()
        let request = NSURLRequest(URL: url)
        //let finalCurrencies
        let task = session.dataTaskWithRequest(request){
            (data, response, error)->Void in
          /*  if let jsonData = data {
                do{
                    let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                    print(jsonObject)
                }
                catch let error{
                    print("Error creating JSON object: \(error)")
                }
            }
            else if let requestError = error{
                print("Error fetching recent photos: \(requestError)")
            }else{
                print("Unexpected error with the request")
            }
 
            */
            
            let result = self.processCurrencyList(data: data, error: error)
           
            completion(result)
            /*
            
            let finalCurrencies = CurrencyLayerAPI.currenciesFromJSONData(data!)
            switch finalCurrencies {
           
            case .Success(let allCurrencies) :
//return allCurrencies
                self.store = allCurrencies
                
                //return allCurrencies
                
            case .Failure(let error):
                print("Error occured\(error)")
            
            //return finalCurrencies
        }
            */
            
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
            getCurrency()
        }
    }
    
    func getCurrency()->Currency
    {
        let currency = Currency(currencyCode: "USD", fullCurrencyName: "US DOllar")
        store.append(currency)
        return currency
    }
    
    func processCurrencyList(data data : NSData?, error : NSError?) -> CurrencyLayerAPIResults{
        guard let jsonData = data else{
            return .Failure(error!)
        }
        return CurrencyLayerAPI.currenciesFromJSONData(jsonData)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
