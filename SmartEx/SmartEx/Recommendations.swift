//
//  Recommendations.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/26/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation
class Recommendations {
    var currency : String?
    var rate : Int?
    
    init(currency: String?, rate: Int?) {
        self.currency = currency
        self.rate = rate
    }
}