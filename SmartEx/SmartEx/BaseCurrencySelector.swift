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
    var currencies = [Currency]()
    var store : CurrencyStore!
    let searchBar = UISearchBar()
    var filteredCurrencies = [Currency]()
    var shouldShowSearchResults = false
    
    
    //closure for formatting the number
    let numberFormatter = {() -> NSNumberFormatter in
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 3
        return nf
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createSearchBar()
        //this function returns the list of currencies in to the currency array and its sorted with alphabetical order
        store.fetchListOfCurrencies(){
            (CurrencyLayerAPIResults)->Void in
            switch CurrencyLayerAPIResults{
            case .Success(let currencies) :
                print("Successfully found \(currencies.count) currencies")
                self.currencies = currencies
                
                dispatch_async(dispatch_get_main_queue(),{
                    //code in this part runs on main thread
                    self.currencies.sortInPlace ({$0.currencyCode < $1.currencyCode})
                    self.tableView.reloadData()
                    
                    
                })
                
            case .Failure(let error):
                print("Error fetching recent photos: \(error)")
                
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        navigationItem.title = "Select Base Currency"
        
    }
    
    //returns number of sections in a tableview
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print(#function)
        
        return 1
    }
    
    //sets height of the cell as 85
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredCurrencies.count == 0 ? 1 : filteredCurrencies.count
        } else {
            return currencies.count
        }
    }
    
    
    //tableView function to determine the cell for each row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // cell could be either noresultsBaseCell prototype or cell prototype
        let cell = tableView.dequeueReusableCellWithIdentifier( shouldShowSearchResults && filteredCurrencies.count == 0 ? "noResultsBaseCell" : "cell",forIndexPath: indexPath) as! BaseCurrencyCell
        
        let currency: Currency
        
        if shouldShowSearchResults {
            
            if filteredCurrencies.count == 0 {
                
                cell.currencyCodeLabel.text = "No matching currencies"
                cell.accessoryType = .None
                return cell
                
            } else {
                
                cell.accessoryType = .DisclosureIndicator
                currency = filteredCurrencies[indexPath.row]
            }
            
        } else {
            
            currency = currencies[indexPath.row]
        }
        
        cell.currencyCodeLabel.text = currency.currencyCode ?? "No data"
        cell.currencyNameLabel.text = currency.fullCurrencyName ?? "No data"
        cell.currencyImage.image = UIImage(named: currency.currencyCode ?? "DCI")
        
        return cell
    }
    //segue to send data to the destinatino view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // showitem segue evokes conversion table view controller and passes base currency value
        if segue.identifier == "ShowItem" {
            navigationItem.title = ""
            
            if shouldShowSearchResults && filteredCurrencies.count>0 {
                if let row = tableView.indexPathForSelectedRow?.row {
                    
                    let baseCurrency = filteredCurrencies[row].currencyCode!   //errorrr
                    
                    let destinationController = segue.destinationViewController as! ConversionTableViewController
                    destinationController.baseCurrency = baseCurrency
                }
            }else{
                if let row = tableView.indexPathForSelectedRow?.row {
                    let baseCurrency = currencies[row].currencyCode
                    
                    let destinationController = segue.destinationViewController as! ConversionTableViewController
                    destinationController.baseCurrency = baseCurrency!
                }
            }
        }
    }
    
    //instantiating a searchbar
    func createSearchBar()
    {
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter Your Base Currency"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    //function that filters the currency list based on the user input
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
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
        //sandra changed it to false
        shouldShowSearchResults = false
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
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    //gesture recognizer to recognize if the background is clicked
    @IBAction func backgroundPressed(){
        view.endEditing(true)
    }
}