
//
//  HistoricalData.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/23/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

class HistoricalData {
    var baseCurrency : String?
    var toCurrency : String?
    var date: String
    var rate : Double?
    init(baseCurrency: String?, toCurrency: String?, date: String, rate: Double?) {
        self.baseCurrency = baseCurrency
        self.toCurrency = toCurrency
        self.date = date
        self.rate = rate
    }
}