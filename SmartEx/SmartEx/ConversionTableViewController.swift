
//
//  ConversionTableViewController.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit

//Controller that manages the conversion of the base currency to the currency user wishes to convert base currency
class ConversionTableViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate
{
    var store = ConversionRateStore()
    
    @IBOutlet var tableView: UITableView!
    var baseCurrency : String = ""
    var conversionFactor : Double? = 1
    
    let searchBar = UISearchBar()
    var filteredCurrencies = [ConversionRate]()
    var shouldShowSearchResults = false
    
    var conversionRates = [ConversionRate](){
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        createSearchBar()
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //set contentInset for tableView
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        
        
        //API gives the data in the form of USD to all 169 currencies.
        //Thus to get the actual data, for the
        store.fetchListOfConversionRates(){
            (ConversionRatesResult)->Void in
            switch ConversionRatesResult{
            //if the conversion rates are properly found, it would execute this case
            case .Success(let conversionRates) :
                print("Successfully found \(conversionRates.count) Conversion Rates")
                self.conversionRates = conversionRates
                
                for conversionRate in self.conversionRates {
                    let code = conversionRate.toCurrency! as NSString
                    let toCurrency = code.substringFromIndex(3)
                    if toCurrency == self.baseCurrency{
                        if conversionRate.rate == 0
                        {
                            self.conversionFactor = (Double)(1/(Double)(999))
                            
                        }else{
                            self.conversionFactor = (Double)(1/(Double)(conversionRate.rate!))
                        }
                        break
                    }
                }
                
                //runs on the main thread
                dispatch_async(dispatch_get_main_queue(),{
                    //UI stuff here on main thread
                    self.conversionRates.sortInPlace ({$0.toCurrency < $1.toCurrency})
                    
                    self.tableView.reloadData()
                })
            //if the conversion rates are not found properly
            case .Failure(let error):
                print("Error fetching recent currency conversions: \(error)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        navigationItem.title = "Currency Converter"
        
    }
    
    //function to create searchbar
    func createSearchBar()
    {
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter Your To Currency"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults{
            return filteredCurrencies.count
        }else{
            print("number of rows in section\(conversionRates.count)")
            return conversionRates.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var rateFromBaseToDestinationCurrency : Double!
        let cell = tableView.dequeueReusableCellWithIdentifier("convertcell",forIndexPath: indexPath) as! ConversionRatesCell
        
        var conversionRate: ConversionRate
        conversionRate = conversionRates[indexPath.row]
        
        
        if shouldShowSearchResults && filteredCurrencies.count>0{
            conversionRate = filteredCurrencies[indexPath.row]
            
        }else{
            conversionRate = conversionRates[indexPath.row]
        }
        
        let code = conversionRate.toCurrency! as NSString
        let toCurrency = code.substringFromIndex(3)
        cell.toCurrencyLabel.text = toCurrency
        
        
        if let conversionFactor = conversionFactor {
            rateFromBaseToDestinationCurrency = conversionFactor*(Double)(conversionRate.rate!)
        }else{
            rateFromBaseToDestinationCurrency = 1*(Double)(conversionRate.rate!)
        }
        
        cell.rateLabel.text =  numberFormatter().stringFromNumber(rateFromBaseToDestinationCurrency)
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
                    
                    let currency = filteredCurrencies[row].toCurrency!   
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
        } else if segue.identifier == "showRecommendations"{
            let destinationsController = segue.destinationViewController as! RecommendationsViewConroller
            destinationsController.myVar = "MYVariable"
            

        
        }
    }
    
    // Set animation on cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        
        // Odd rows come from left side
        var animateTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        // Even rows come from right side
        if (indexPath.row % 2 == 0) {
            animateTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 0)
        }
        cell.layer.transform = animateTransform
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    //closure
    let numberFormatter = {() -> NSNumberFormatter in
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 1
        nf.maximumFractionDigits = 3
        return nf
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
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
        shouldShowSearchResults = true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    //to handle the gesture recognizer
    @IBAction func backgroundPressed(){
        view.endEditing(true)
    }
}
