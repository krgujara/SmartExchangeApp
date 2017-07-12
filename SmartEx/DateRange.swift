//
//  DateRange.swift
//  SmartEx
//
//  Created by Komal Gujarathi on 4/23/17.
//  Copyright © 2017 Komal Gujarathi. All rights reserved.
//

import Foundation

//this file extends the NSCalendar and creates a dateRange function which is used in the historical and recommendation pakages

func > (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == .OrderedDescending
}

extension NSCalendar {
    func dateRange(startDate startDate: NSDate, endDate: NSDate, stepUnits: NSCalendarUnit, stepValue: Int) -> DateRange {
        let dateRange = DateRange(calendar: self, startDate: startDate, endDate: endDate,
                                  stepUnits: stepUnits, stepValue: stepValue, multiplier: 0)
        return dateRange
    }
}


struct DateRange :SequenceType {
    
    var calendar: NSCalendar
    var startDate: NSDate
    var endDate: NSDate
    var stepUnits: NSCalendarUnit
    var stepValue: Int
    private var multiplier: Int
    
    func generate() -> Generator {
        return Generator(range: self)
    }
    
    struct Generator: GeneratorType {
        
        var range: DateRange
        
        mutating func next() -> NSDate? {
            guard let nextDate = range.calendar.dateByAddingUnit(range.stepUnits,
                                                                 value: range.stepValue * range.multiplier,
                                                                 toDate: range.startDate,
                                                                 options: []) else {
                                                                    return nil
            }
            if nextDate > range.endDate {
                return nil
            }
            else {
                range.multiplier += 1
                return nextDate
            }
        }
    }
}


