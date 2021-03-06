
//
//  BinaryFloatingPointExtention.swift
//  WorkCalculator
//
//  Created by Loaner on 4/20/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

extension BinaryFloatingPoint {
    
    var droppedFirst: String{
        return String(String(describing: self).characters.dropFirst())
    }
    
    public func rounded(toPlaces places: Int) -> Self {
        let divisor = Self(pow(10.0, Double(places)))
        return (self * divisor).rounded() / divisor
//        guard places >= 0 else { return self }
//        let divisor = Self((0..<places).reduce(1.0) { $0 * 10.0 })
//        return (self * divisor).rounded() / divisor
    }
    
    var stringValue: String{
        return String(describing: self)
    }
}

extension Double{
    var minuteToHours: Double{
        return (self/60).rounded(toPlaces: 2)
    }
    
    
}
