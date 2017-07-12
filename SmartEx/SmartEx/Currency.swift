//
//  Currency.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/5/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation


//Model class to Store the currency information
class Currency {
    var currencyCode : String?
    var fullCurrencyName : String?
    
    init(currencyCode: String?, fullCurrencyName: String?) {
        self.currencyCode = currencyCode
        self.fullCurrencyName = fullCurrencyName
    }
}