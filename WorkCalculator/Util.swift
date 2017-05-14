//
//  Util.swift
//  WorkCalculator
//
//  Created by Loaner on 5/10/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class Util{
    
    //MARK: Tedious fix methods
    class func replacePeriod(s: String) -> String{
        var myString = s
        
        let remove: [String] = ["."]
        
        for removable in remove{
            myString = myString.replacingOccurrences(of: removable, with: "_")
        }
        return myString
    }
    
    class func removeOptional(s: String) -> String{
        let o = s
        let o2 = o.replacingOccurrences(of: "Optional(", with: "")
        let mut = o2.replacingOccurrences(of: ")", with: "")
        return mut
    }
    
    //MARK: DATE DATA TO STRING
    class func DateString(from date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    //MARK: CREATE DATE FROM STRING
    class func Date(from dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: dateString)!
        return date
    }

    
}
