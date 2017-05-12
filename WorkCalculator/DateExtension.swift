//
//  DateExtension.swift
//  WorkCalculator
//
//  Created by Loaner on 5/10/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

extension Date {
    var stringValue:String? {
        return Util.DateString(from: self)
    }
    var oneMonthAgo: Date!{
        return self.addingTimeInterval(60 * 60 * 24 * -31)
    }
    var sevenDaysLater: Date!{
        return self.addingTimeInterval(60 * 60 * 24 * 7)
    }
}
