//
//  ConversionRatesCell.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit

class ConversionRatesCell : UITableViewCell
{
    @IBOutlet weak var flagImage : UIImageView!
    @IBOutlet weak var toCurrencyLabel : UILabel!
    @IBOutlet weak var rateLabel : UILabel!

    override func prepareForReuse() {
        
        flagImage?.image = nil
        toCurrencyLabel.text = nil
        rateLabel?.text = nil
    }
    
}
