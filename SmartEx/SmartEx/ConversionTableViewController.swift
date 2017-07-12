
//
//  ConversionTableViewController.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit
class ConversionTableViewController : UITableViewController, UISearchBarDelegate
{
    var store = ConversionRateStore()
 
    var baseCurrency : String = ""
    var conversionFactor : Double? = 1
    
    let searchBar = UISearchBar()
    var filteredCurrencies = [ConversionRate]()
    var shouldShowSearchResults = false
    
    var conversionRates = [ConversionRate](){
        didSet{
            //print("Conversino Factor: \(conversionFactor)")
        }
    }
    
    override func viewDidLoad() {
        
        
        createSearchBar()

        
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
                //print("Base Currency View did Load: \(self.baseCurrency)")
                for conversionRate in self.conversionRates {
                    let code = conversionRate.toCurrency! as NSString
                    let toCurrency = code.substringFromIndex(3)
                    if toCurrency == self.baseCurrency{
                        if conversionRate.rate == 0
                        {
                            //print("ConversionRate and ConversionFactor\(conversionRate.rate) + \(self.conversionFactor!)")
                            self.conversionFactor = (Double)(1/(Double)(999))
                            
                        }else{
                            //self.conversionFactor = (Double)(1/(Double)(conversionRate.rate!))
                            
                            //print("ConversionRate and ConversionFactor\(conversionRate.rate) + \(self.conversionFactor!)")
                            
                        }
                        break
                    }
                }
                dispatch_async(dispatch_get_main_queue(),{
                    //UI stuff here on main thread
                    self.conversionRates.sortInPlace ({$0.toCurrency > $1.toCurrency})
                
                    self.tableView.reloadData()
                })
                
            case .Failure(let error):
                print("Error fetching recent photos: \(error)")
                //return finalCurrencies
            }
        }
    }
    
    
    func createSearchBar()
    {
        //print(#function)
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter Your To Currency"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("Base Currency : \(baseCurrency)")
        self.navigationController?.navigationBarHidden = false
        //let controller = storyboard?.instantiateViewControllerWithIdentifier("View2")
        
        //self.navigationController!.pushViewController(controller!, animated: true)
        navigationItem.title = "Currency Converter"
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //print(#function)
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(#function)
        
    
        if shouldShowSearchResults{
            return filteredCurrencies.count
        }else{
            print("number of rows in section\(conversionRates.count)")
           return conversionRates.count
        }

    
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print(#function)
        var rateFromBaseToDestinationCurrency : Double!
        let cell = tableView.dequeueReusableCellWithIdentifier("convertcell",forIndexPath: indexPath) as! ConversionRatesCell
       
        var conversionRate: ConversionRate
        conversionRate = conversionRates[indexPath.row]
        
        
        if shouldShowSearchResults {
            conversionRate = filteredCurrencies[indexPath.row]    //errorrr
            
        }else{
            conversionRate = conversionRates[indexPath.row]
        }

        let code = conversionRate.toCurrency! as NSString
        let toCurrency = code.substringFromIndex(3)
        cell.toCurrencyLabel.text = toCurrency
        
        if let conversionFactor = conversionFactor {
            rateFromBaseToDestinationCurrency = conversionFactor*(Double)(conversionRate.rate!)
            //print("Rate: \(rateFromBaseToDestinationCurrency)")
        }else{
            rateFromBaseToDestinationCurrency = 1*(Double)(conversionRate.rate!)
            //print("Rate1 : \(rateFromBaseToDestinationCurrency)")
        }
        
        cell.rateLabel.text =  numberFormatter().stringFromNumber(rateFromBaseToDestinationCurrency)
        //print("ConversionRate.toCurrency"+conversionRate.toCurrency)
        
        //print("To Currency: \(toCurrency)")
        //print("Base Currency: \(baseCurrency)")
        
        cell.flagImage.image = UIImage(named: toCurrency)
        
        cell.updateLabels()
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue invoked.")
        
        if segue.identifier == "ShowDetailSegue" {
            navigationItem.title = ""
             if shouldShowSearchResults && filteredCurrencies.count>0 {
                if let row = tableView.indexPathForSelectedRow?.row {
                    
                    let currency = filteredCurrencies[row].toCurrency!   //errorrr
                    let destinationController = segue.destinationViewController as! HistoricalDataViewController
                    destinationController.baseCurrencyForHistoricalData = String("USD" + baseCurrency)
                    destinationController.toCurrencyForHistoricalData = currency
                }
             }
            else
            {
            if let row = tableView.indexPathForSelectedRow?.row {
                let currency = conversionRates[row].toCurrency
                
                let destinationController = segue.destinationViewController as! HistoricalDataViewController
                destinationController.baseCurrencyForHistoricalData = String("USD" + baseCurrency)
                destinationController.toCurrencyForHistoricalData = currency!
            }
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

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //print(#function)
        
        filteredCurrencies = conversionRates.filter({ (Currency1) -> Bool in
            return Currency1.toCurrency!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
        
        if searchText != ""
        {
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }else{
            shouldShowSearchResults = false
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //print(#function)
        
        shouldShowSearchResults = true
        // tableView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //print(#function)
        
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //print(#function)
        
        shouldShowSearchResults = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    @IBAction func backgroundPressed(){
        view.endEditing(true)
    }

    
    
}
