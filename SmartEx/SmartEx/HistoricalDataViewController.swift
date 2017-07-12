//
//  HistoricalDataViewController.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/7/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit
import Charts

class HistoricalDataViewController : UIViewController
{
    var toCurrencyForHistoricalData : String = ""
    var baseCurrencyForHistoricalData : String = ""
    
    @IBOutlet weak var lineChartView: LineChartView!
    var months: [String]!
    var store = HistoricalDataStore()
    var historicalData = [HistoricalData]()
    var x_coordinates = [String]()
    var y_coordinates = [Double]()
    
    //closure
    let numberFormatter = {() -> NSNumberFormatter in
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 1
        nf.maximumFractionDigits = 1
        return nf
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Historical Data"
        // Do any additional setup after loading the view, typically from a nib.
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startDate = NSDate(timeIntervalSinceNow: -24*60*60*30-1)
        
        let endDate = NSDate(timeIntervalSinceNow: 0)
        let dateRange = calendar.dateRange(startDate: startDate,
                                           endDate: endDate,
                                           stepUnits: .Day,
                                           stepValue: 1)
        let datesInRange = Array(dateRange)
      
            for date in datesInRange{
                //print(date)
                let styler = NSDateFormatter()
                styler.dateFormat = "yyyy-MM-dd"
                let dateString = styler.stringFromDate(date)

                self.store.fetchHistoricalData(self.baseCurrencyForHistoricalData, toCurrency :self.toCurrencyForHistoricalData, date : dateString, completion :{(HistoricalDataResult)->Void in
                    switch HistoricalDataResult{
                        
                    case .Success(let HistoricalData) :
                        self.historicalData.append(HistoricalData)
                        
                        if self.historicalData.count == 30 {
                            print("Final Historical Data Count: \(self.historicalData.count)")
                            
                            //var maxNumber = Double()
                            //var minNumber = Double()
                            for data in self.historicalData{
                                print("\(data.date) \(data.rate!)")
                                self.x_coordinates.append(String(data.date))
                                let y_coordinates_string = self.numberFormatter().stringFromNumber(data.rate!)
                                self.y_coordinates.append(Double(y_coordinates_string!)!)
                               
                            }
                           // self.setChart(x_coordinates, values: y_coordinates)
                            
                            
                        }
                        //self.setChart(months, values: unitsSold)
                        //sleep(10)
                        self.setChart(self.x_coordinates, values: self.y_coordinates)
                        
                    case .Failure(let error):
                        print("Error fetching Data: \(error)")
                    }
                })
         }
    }
    
    override func viewWillAppear(animated: Bool) {
        print("Base Currency :  \(baseCurrencyForHistoricalData)")
        print("To Currency : \(toCurrencyForHistoricalData)")
    }
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Conversion Rate Variations")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
    }
}