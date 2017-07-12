//
//  RecommendationTableViewController.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/26/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit
class RecommendationsViewConroller : UITableViewController{
    
    var myVar : String = ""
    
    var store = RecommendationsStore()
    var recommendationsData = [Recommendations]()
    var recommendationDataStartDate = [Recommendations]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(myVar)
        
        
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Recommendationed Currencies"
        // Do any additional setup after loading the view, typically from a nib.
        
        //let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startDate = NSDate(timeIntervalSinceNow: -24*60*60*30-1)
        
        let endDate = NSDate(timeIntervalSinceNow: 0)
        //let dateRange = calendar.dateRange(startDate: startDate,
                                         //  endDate: endDate,
                                          // stepUnits: .Day,
                                          // stepValue: 1)
        //let datesInRange = Array(dateRange)
        
        //for date in datesInRange{
            //print(date)
            let styler = NSDateFormatter()
            styler.dateFormat = "yyyy-MM-dd"
            let dateString = styler.stringFromDate(endDate)
        print("Conversion Rates Fordate: \(dateString)")
        self.store.fetchHistoricalDataForRecommendations("USD", toCurrency : "", date: dateString, completion: {(RecommendationsResult)->Void in
                switch RecommendationsResult{
                    
                case .Success(let recommendationsData) :
                    
                    print("Successfully found \(recommendationsData.count) Rates")
                    self.recommendationsData = recommendationsData
                    
                    for dataForOneDay in self.recommendationsData {
                        print(dataForOneDay.currency)
                        print(dataForOneDay.rate)
                    
                    }
                case .Failure(let error):
                    print("Error fetching Data: \(error)")
                }
            })
        //}
        
        let dateStringstart = styler.stringFromDate(startDate)
        print("Conversion Rates Start Date: \(dateStringstart)")
        self.store.fetchHistoricalDataForRecommendations("USD", toCurrency : "", date: dateStringstart, completion: {(RecommendationsResult)->Void in
            switch RecommendationsResult{
                
            case .Success(let recommendationsData) :
                
                print("Successfully found \(recommendationsData.count) Rates")
                self.recommendationDataStartDate = recommendationsData
                
                for dataForOneDay in self.recommendationDataStartDate {
                    print(dataForOneDay.currency)
                    print(dataForOneDay.rate)
                }
                //self.setChart(months, values: unitsSold)
                if self.recommendationDataStartDate.count == 30{
                    //runs on the main thread
                    dispatch_async(dispatch_get_main_queue(),{
                        //UI stuff here on main thread
                        //self.conversionRates.sortInPlace ({$0.toCurrency < $1.toCurrency})
                        
                        self.tableView.reloadData()
                        
                    })
                    
                }
            case .Failure(let error):
                print("Error fetching Data: \(error)")
            }
        })
        
        
    }
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Currency Converter"
        
        print(myVar)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recommendations",forIndexPath: indexPath) as! RecommendationsCell
        
        
        cell.currency.text = "MYCURRR"
        cell.currencyImage.image = UIImage(named: "USD")
        
        return cell
        
    }
    
    
    
}