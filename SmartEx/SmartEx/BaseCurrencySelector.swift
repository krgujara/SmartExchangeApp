//
//  BaseCurrencySelector.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/5/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit
class BaseCurrencySelector : UITableViewController, UISearchBarDelegate
{
    //var currenciesStore = CurrencyStore()
    var currencies = [Currency]()
        
        var store : CurrencyStore!
    //var currencies = currencyStore.store
    let searchBar = UISearchBar()
    var filteredCurrencies = [Currency]()
    var shouldShowSearchResults = false
    
    //var searchController : UISearchController!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //currencies.fetchListOfCurrencies()
        //configureSearchController()
        
        createSearchBar()

        
        store.fetchListOfCurrencies(){
            (CurrencyLayerAPIResults)->Void in
            switch CurrencyLayerAPIResults{
                case .Success(let currencies) :
                //return allCurrencies
                print("Successfully found \(currencies.count) currencies")
                self.currencies = currencies
                //self.tableView.reloadData()
                //return allCurrencies
                
                dispatch_async(dispatch_get_main_queue(),{
                    //UI stuff here on main thread
                    self.currencies.sortInPlace ({$0.currencyCode < $1.currencyCode})
                    self.tableView.reloadData()
                    
                    
                })
                
                case .Failure(let error):
                print("Error fetching recent photos: \(error)")
                
                //return finalCurrencies
                }
       }
        //self.searchBar.text = ""
       //shouldShowSearchResults = false
        //self.tableView.reloadData()
       self.tableView.reloadData()
        
    }
    //closure
    let numberFormatter = {() -> NSNumberFormatter in
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 1
        nf.maximumFractionDigits = 2
        return nf
    }

    func createSearchBar()
    {
        //print(#function)
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter Your Base Currency"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print(#function)
        
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(#function)
        
        if shouldShowSearchResults{
            return filteredCurrencies.count
        }else{
            print("number of rows in section\(currencies.count)")
            return currencies.count
        }
    }
    override func viewWillAppear(animated: Bool) {
        //print(#function)
        
        navigationItem.title = "Select Base Currency"
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print(#function)
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! BaseCurrencyCell
        let currency: Currency
        
        if shouldShowSearchResults { 
            currency = filteredCurrencies[indexPath.row]    //errorrr
            
        }else{
            currency = currencies[indexPath.row]
        }
        if let currencyCode = currency.currencyCode, fullCurrencyName = currency.fullCurrencyName{
        cell.currencyCodeLabel.text = currencyCode
        cell.currencyNameLabel.text = fullCurrencyName
        cell.currencyImage.image = UIImage(named: currencyCode)
        }else{
            cell.currencyCodeLabel.text = "no data"
            cell.currencyNameLabel.text = "no data"
            cell.currencyImage.image = UIImage(named: currency.currencyCode!)
        }
            //use of dynamic type
        cell.updateLabels()
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue invoked.")
      
        if segue.identifier == "ShowItem" {
            navigationItem.title = ""
            
            if shouldShowSearchResults && filteredCurrencies.count>0 {
                if let row = tableView.indexPathForSelectedRow?.row {
                    
                    let baseCurrency = filteredCurrencies[row].currencyCode!   //errorrr
                    
                    let destinationController = segue.destinationViewController as! ConversionTableViewController
                    destinationController.baseCurrency = baseCurrency
                    //print(baseCurrency)
                }
            }else{
                if let row = tableView.indexPathForSelectedRow?.row {
                    let baseCurrency = currencies[row].currencyCode
                    
                    let destinationController = segue.destinationViewController as! ConversionTableViewController
                    destinationController.baseCurrency = baseCurrency!
                    //print(baseCurrency)
                }
            }
        }
        //searchController.active = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //print(#function)
        
        filteredCurrencies = currencies.filter({ (Currency1) -> Bool in
            return Currency1.currencyCode!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
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
        
       /*if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }*/
        searchBar.resignFirstResponder()
    }
    /*
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        //filter the data and get only those currency codes that match search text
        
        filteredCurrencies = currencies.filter({(currency) -> Bool in
            let currencyText: NSString = currency.currencyCode
            
            return (currencyText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        //reload tableview
        tableView.reloadData()
    }
    */
    
    // Set animation on cell
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
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

    
    @IBAction func backgroundPressed(){
        view.endEditing(true)
    }
}

