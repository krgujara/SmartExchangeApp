//
//  ConversionTableViewController.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit
class ConversionTableViewController : UITableViewController
{
    //var conversions = ConversionRateStore().conversionStore
    var store = ConversionRateStore()
  
    var conversionRates = [ConversionRate](){
        didSet{
            print("Conversino Factor: \(conversionFactor)")
        }
    }

    var baseCurrency : String = ""
    var conversionFactor : Double? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchListOfConversionRates(){
            (ConversionRatesResult)->Void in
            switch ConversionRatesResult{
            case .Success(let conversionRates) :
                //return allCurrencies
                print("Successfully found \(conversionRates.count) Conversion Rates")
                self.conversionRates = conversionRates
                //self.tableView.reloadData()
                //return allCurrencies
                
                print("Base Currency View did Load: \(self.baseCurrency)")
                for conversionRate in self.conversionRates{
                    let code = conversionRate.toCurrency as NSString
                    let toCurrency = code.substringFromIndex(3)
                    if toCurrency == self.baseCurrency{
                        self.conversionFactor = (Double)(1/(Double)(conversionRate.rate))
                        print("ConversionRate and ConversionFactor\(conversionRate.rate) + \(self.conversionFactor!)")
                        break
                    }
                }

                
                dispatch_async(dispatch_get_main_queue(),{
                    //UI stuff here on main thread
                    self.tableView.reloadData()
                    
                })
                
            case .Failure(let error):
                print("Error fetching recent photos: \(error)")
                
                //return finalCurrencies
            }
        }
        

        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("Base Currency : \(baseCurrency)")
        self.navigationController?.navigationBarHidden = false
        //let controller = storyboard?.instantiateViewControllerWithIdentifier("View2")
        
        //self.navigationController!.pushViewController(controller!, animated: true)
        navigationItem.title = "Currency Converter"
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print(#function)
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return conversionRates.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(#function)
        var rateFromBaseToDestinationCurrency : Double!
        let cell = tableView.dequeueReusableCellWithIdentifier("convertcell",forIndexPath: indexPath) as! ConversionRatesCell
       
        let conversionRate: ConversionRate
        conversionRate = conversionRates[indexPath.row]

        let code = conversionRate.toCurrency as NSString
        let toCurrency = code.substringFromIndex(3)
        cell.toCurrencyLabel.text = toCurrency
        
        if let conversionFactor = conversionFactor {
            rateFromBaseToDestinationCurrency = conversionFactor*(Double)(conversionRate.rate)
            print("Rate: \(rateFromBaseToDestinationCurrency)")
        }else{
            rateFromBaseToDestinationCurrency = 1*(Double)(conversionRate.rate)
            print("Rate1 : \(rateFromBaseToDestinationCurrency)")
        }
        
        cell.rateLabel.text =  numberFormatter().stringFromNumber(rateFromBaseToDestinationCurrency)
        //print("ConversionRate.toCurrency"+conversionRate.toCurrency)
        
        print("To Currency: \(toCurrency)")
        print("Base Currency: \(baseCurrency)")
        
        cell.flagImage.image = UIImage(named: toCurrency)
        
        cell.updateLabels()
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue invoked.")
        
        if segue.identifier == "ShowDetailSegue" {
            navigationItem.title = ""
            if let row = tableView.indexPathForSelectedRow?.row {
                let currency = conversionRates[row].toCurrency
                
                
                let destinationController = segue.destinationViewController as! HistoricalDataViewController
                destinationController.currency = currency
            }
        }
    }

    //closure
    let numberFormatter = {() -> NSNumberFormatter in
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 1
        nf.maximumFractionDigits = 1
        return nf
    }

}
