//
//  BaseCurrencyCell.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit

//class which has outlets to all the properties of base Currency

class BaseCurrencyCell : UITableViewCell
{
    
    @IBOutlet weak var currencyImage: UIImageView!
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    @IBOutlet weak var currencyNameLabel: UILabel!
  
    //this func enables the nocurrency prototype cell to use this same class by formatting the previous information
    override func prepareForReuse() {
        
        currencyImage?.image = nil
        currencyCodeLabel?.text = nil
        currencyNameLabel?.text = nil
    }

}

