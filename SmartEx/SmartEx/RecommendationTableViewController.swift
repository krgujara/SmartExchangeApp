//
//  RecommendationTableViewController.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/26/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit
class RecommendationsViewConroller : UITableViewController{
    
 
    
    var store = RecommendationsStore()
    var recommendationsData = [Recommendations]()
    var differenceArray = [Recommendations]()
    var recommendationDataStartDate = [Recommendations]()
    
    var historicalDataStartDateFetched = false
    var historicalDataCurrentDateFetched = false
    static var AlphaValue = 0.3
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Recommended Currencies"
        
        let startDate = NSDate(timeIntervalSinceNow: -24*60*60*30-1)
        
        let endDate = NSDate(timeIntervalSinceNow: 0)
        
            let styler = NSDateFormatter()
            styler.dateFormat = "yyyy-MM-dd"
            let dateString = styler.stringFromDate(endDate)
        
        //this function obtains live conversion rates for all currencies
        
        self.store.fetchHistoricalDataForRecommendations("USD", toCurrency : "", date: dateString, completion: {(RecommendationsResult)->Void in
            
                self.historicalDataCurrentDateFetched = true
            
                switch RecommendationsResult{
                    
                case .Success(let recommendationsData) :
                    
                    
                    self.recommendationsData = recommendationsData
                    
                    
                    
                case .Failure(let error):
                    print("Error fetching Data: \(error)")
                }
            
            self.checkAndCalculateRecommendations()
            
            })
        //}
        
        let dateStringstart = styler.stringFromDate(startDate)
        
        //this func returns the data for 30th day before now.
        self.store.fetchHistoricalDataForRecommendations("USD", toCurrency : "", date: dateStringstart, completion: {(RecommendationsResult)->Void in
            
            self.historicalDataStartDateFetched = true
            
            switch RecommendationsResult{
                
            case .Success(let recommendationsData) :
                
                self.recommendationDataStartDate = recommendationsData
                

                
                
            case .Failure(let error):
                print("Error fetching Data: \(error)")
            }
            
            self.checkAndCalculateRecommendations()
        })
    }
    
    // this function creates the statistical metric of monthly differential using the live data and 30th day data from now
    private func checkAndCalculateRecommendations() {
        
        //this is to makesure that both the data sets are created before processing
        
        if historicalDataStartDateFetched && historicalDataCurrentDateFetched {
            
            if self.recommendationDataStartDate.count > 100 {
                //runs on the main thread
                dispatch_async(dispatch_get_main_queue(),{
                    //UI stuff here on main thread
                    
                    
                    for i in 0..<self.recommendationDataStartDate.count{
                        var diff = ((self.recommendationDataStartDate[i].rate! - self.recommendationsData[i].rate!)/self.recommendationDataStartDate[i].rate!)*100
                        if diff <= 0 {
                            diff = diff * (-1)
                        }
                        let sixLetterCurrencyCode = self.recommendationDataStartDate[i].currency! as NSString
                        
                        let recoObj = Recommendations(currency: sixLetterCurrencyCode.substringFromIndex(3) , rate: diff)
                        self.differenceArray.append(recoObj)
                        self.differenceArray.sortInPlace({$0.rate! > $1.rate!})
                    }
                    
                    self.tableView.reloadData()
                    
                })
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
       
        navigationItem.title = "Safe House"
        
       
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows will be maximum 7 as top 7 currencies will be displayed.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return differenceArray.count == 0 ? 0 : min(differenceArray.count, 7)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recommendations",forIndexPath: indexPath) as! RecommendationsCell
        
        if let text = self.differenceArray[indexPath.row].currency, let fluctuation = self.differenceArray[indexPath.row].rate {
            cell.currency.text = text
            cell.fluctuation.text = numberFormatter().stringFromNumber(fluctuation)
        } else{
            cell.currency.text = nil
            cell.fluctuation.text = nil
        }
        
        

        let currencyImageCode = self.differenceArray[indexPath.row].currency!

        cell.currencyImage.image = UIImage(named: currencyImageCode)
        cell.backgroundColor = cellColorForIndex(indexPath)
        return cell
        
    }
    
    
    let numberFormatter = {() -> NSNumberFormatter in
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 1
        nf.maximumFractionDigits = 3
        nf.usesSignificantDigits = true
        nf.maximumSignificantDigits = 3
        
        return nf
    }
    
    
    func cellColorForIndex(indexPath:NSIndexPath) -> UIColor{
        
        let Alpha = CGFloat(((0.6+Double(indexPath.row))/7) == 0 ? 0.15 : ((0.6+Double(indexPath.row))/7))
        
        
        return UIColor(red: 110 ,green: 110,blue: 110, alpha: Alpha)
    }
    
    
    
    
    
    
}