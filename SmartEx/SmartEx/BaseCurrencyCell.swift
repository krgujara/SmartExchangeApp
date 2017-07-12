//
//  BaseCurrencyCell.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import UIKit
class BaseCurrencyCell : UITableViewCell
{
    
    @IBOutlet weak var currencyImage: UIImageView!
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        currencyCodeLabel.font = bodyFont
        
        let captionFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        currencyNameLabel.font = captionFont
        
        
    }

}

