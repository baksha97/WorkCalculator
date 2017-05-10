//
//  WorkDay.swift
//  myHoursV1
//
//  Created by Loaner on 2/27/17.
//  Copyright © 2017 Loaner. All rights reserved.
//

import Foundation
import Firebase

struct WorkDay{
    
    var store_startTime: String?
    var store_endTime: String?
    
    var delivery_startTime: String?
    var delivery_endTime: String?
    
    let ref: FIRDatabaseReference?
    
    init(store_startTime: Date, store_endTime: Date) {
        self.store_startTime = store_startTime.stringValue
        self.store_endTime = store_endTime.stringValue
        self.ref = nil
    }
    
    init(delivery_startTime: Date, delivery_endTime: Date) {
        self.delivery_startTime = delivery_startTime.stringValue
        self.delivery_endTime = delivery_endTime.stringValue
        self.ref = nil
    }
    
    init(store_startTime: Date, store_endTime: Date, delivery_startTime: Date, delivery_endTime: Date) {
        self.store_startTime = store_startTime.stringValue
        self.store_endTime = store_endTime.stringValue
        self.delivery_startTime = delivery_startTime.stringValue
        self.delivery_endTime = delivery_endTime.stringValue
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        store_startTime = snapshotValue["store-start"] as? String
        store_endTime = snapshotValue["store-end"] as? String
        delivery_startTime = snapshotValue["delivery-start"] as? String
        delivery_endTime = snapshotValue["delivery-end"] as? String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "store-start":store_startTime ?? "nil",
            "store-end":store_endTime ?? "nil",
            "delivery-start":delivery_startTime ?? "nil",
            "delivery-end":delivery_endTime ?? "nil"
        ]
    }
}
