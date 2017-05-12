//
//  NSDate+Utils.swift
//  Swift Extensions
//

import Foundation
import UIKit

extension Date {
    var dateOneMonthAgo: Date!{
        return self.addingTimeInterval(60 * 60 * 24 * -31)
    }
}
