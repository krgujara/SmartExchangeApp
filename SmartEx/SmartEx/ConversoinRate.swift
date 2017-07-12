//
//  ConversoinRate.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/6/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

//conversion Rate class holds all properties relating to Conversion of one currency to the other currency which user wants to see the conversions to
class ConversionRate {
    var toCurrency : String?
    var rate : Int?
    
    init(toCurrency: String, rate: Int) {
        self.toCurrency = toCurrency
        self.rate = rate
    }
}