//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

extension String {
    var doubleValue:Double? {
        return Double(self)
    }
    var integerValue:Int? {
        return Int(self)
    }
    var dateValue:Date?{
        return Util.Date(from: self)
    }
}
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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        return dateFormatter.string(from: date)
    }
    //MARK: CREATE DATE FROM STRING
    class func Date(from dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss SSSZ"
        let date = dateFormatter.date(from: dateString)!
        return date
    }
    
    
}

let date = Date()

let string = Util.DateString(from: date)

let s = "hello"


string.dateValue






