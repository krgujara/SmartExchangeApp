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
        nf.maximumFractionDigits = 3
        return nf
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Historical Data"
        
        let (calendar, startDate, endDate) = createStartDateEndDateAndCalendar()
        
        let dateRange = calendar.dateRange(startDate: startDate,
                                           endDate: endDate,
                                           stepUnits: .Day,
                                           stepValue: 1)
        let datesInRange = Array(dateRange)
      
            for date in datesInRange{
                
                let styler = NSDateFormatter()
                styler.dateFormat = "yyyy-MM-dd"
                let dateString = styler.stringFromDate(date)
              
                //this func returns the data with user selected base currency
                self.store.fetchHistoricalData(self.baseCurrencyForHistoricalData, toCurrency :self.toCurrencyForHistoricalData, date : dateString, completion :{(HistoricalDataResult)->Void in
                    switch HistoricalDataResult{
                        
                    case .Success(let HistoricalData) :
                        self.historicalData.append(HistoricalData)
                       
                        //this loop is to ensure that the chart thread gets populated only after all the values in the historicaldata array are obtained.
                        if self.historicalData.count == 30 {
                            
                            
                            
                            for data in self.historicalData{
                                
                                self.x_coordinates.append(String(data.date))
                                let y_coordinates_string = self.numberFormatter().stringFromNumber(data.rate!)
                                
                                //passing exchange rates and dates as y and x params to chart respectvely.
                                self.y_coordinates.append(Double(y_coordinates_string!)!)
                               
                            }
                           
                            
                            
                        }
                        
                        
                        if self.historicalData.count == 30{
                        //runs on the main thread
                        dispatch_async(dispatch_get_main_queue(),{
                            
                              self.setChart(self.x_coordinates, values: self.y_coordinates)
                        })

                        }
                        
                      
                        
                    case .Failure(let error):
                        print("Error fetching Data: \(error)")
                    }
                })
         }
    }
    
    
    
    //setChart instantiats the linechartdata class and also animates it
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Conversion Rate Variations")
        applyTheme(to: lineChartDataSet)
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.legend.form = .Line
        
        lineChartView.data = lineChartData
        lineChartView.data?.highlightEnabled = true
        
        lineChartView.animate(xAxisDuration: 3, easingOption: .EaseInOutQuart)
    }
    
    private func applyTheme(to s: LineChartDataSet) {
        
        let gradientColors = [
            
            ChartColorTemplates.colorFromString("#8FEBFE").CGColor,
            ChartColorTemplates.colorFromString("#B7EFFE").CGColor
        ]
        
        let gradient = CGGradientCreateWithColors(nil, gradientColors, nil)!
        s.fillAlpha = 0.5
        s.fill = ChartFill.fillWithLinearGradient(gradient, angle: 90)
        s.drawFilledEnabled = true
        
    }
    
    //function which returns tuple of calendar, startdate and enddate
    
    internal func createStartDateEndDateAndCalendar()->(NSCalendar, NSDate, NSDate){
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startDate = NSDate(timeIntervalSinceNow: -24*60*60*30-1)
        
        let endDate = NSDate(timeIntervalSinceNow: 0)
    return (calendar, startDate, endDate)
    }
}