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
    var currency : String = ""
    @IBOutlet weak var lineChartView: LineChartView!
    //@IBOutlet weak var barChartView: BarChartView!
    var months: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Historical Data"
        // Do any additional setup after loading the view, typically from a nib.
        
        months = ["Jan", "Feb", "Mar", "Apr", "May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        let unitsSold = [20.0,4.0,6.0,3.0,12.0,16.0,4.0,18.0,2.0,4.0,5.0,12.0]
        setChart(months, values: unitsSold)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("Currency : + \(currency)")
    }
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color1 = UIColor.redColor()
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
            colors.append(color1)
        }
        
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
}