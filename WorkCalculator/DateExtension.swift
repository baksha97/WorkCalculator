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
    
    var firebaseTitle: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a"
        return dateFormatter.string(from: self)
    }
    
    var mediumDescription: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var longDescription: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a"
        return dateFormatter.string(from: self)
    }
    
    var oneMonthAgo: Date!{
        return self.addingTimeInterval(60 * 60 * 24 * -30)
    }
    
    var twoWeeksAgo: Date!{
        return self.addingTimeInterval(60 * 60 * 24 * -14)
    }
    
    var twoWeeksLater: Date!{
        return self.addingTimeInterval(60 * 60 * 24 * 14)
    }
    
    
    var sevenDaysLater: Date!{
        return self.addingTimeInterval(60 * 60 * 24 * 7)
    }
    
    var hoursString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)

    }
    
    public func minutes(to date: Date) -> Double{
        let userCalendar = Calendar.current
        let comp = userCalendar.dateComponents([.second], from: self, to: date)
        return Double(comp.second!)/60
    }
    
    public func minutes(from date: Date) -> Double{
        let userCalendar = Calendar.current
        let comp = userCalendar.dateComponents([.minute], from: date, to: self)
        return Double(comp.minute!)
    }
}
