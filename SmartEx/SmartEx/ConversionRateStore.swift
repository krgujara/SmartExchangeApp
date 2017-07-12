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
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)}()
    
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
    
    func processCurrencyList(data data : NSData?, error : NSError?) -> LiveCurrencyLayerAPIResults{
        guard let jsonData = data else{
            return .Failure(error!)
        }
        return LiveCurrencyLayerAPI.liveCurrenciesFromJSONData(jsonData)
    }
    
    
    //-----------
  //  var listOfCurrencyConversion = [ "USDEUR" , "USDAUD" , "USDINR" ]
   // var listOfRates = [23,45,42]
    
    init(){
        getAllConversionRates()
    }
    func getAllConversionRates()
    {
        fetchListOfConversionRates(){
            (LiveCurrencyLayerAPIResults)->Void in
            switch LiveCurrencyLayerAPIResults{
            case .Success(let conversionRates) :
                //return allCurrencies
                print("Successfully found \(conversionRates.count) conversion rates")
                //self.conversionStore = conversionRates
                              //return allCurrencies
                for conversionRate in self.conversionStore {
                    print("To Currency : \(conversionRate.toCurrency) Conversion Rate: \(conversionRate.rate)")
                    //self.listOfCurrencyConversion.append(conversionRate.toCurrency)
                    //self.listOfRates.append(conversionRate.rate)
                }
                
            case .Failure(let error):
                print("Error fetching recent photos: \(error)")
                
                //return finalCurrencies
            }
        }
       }
   }
