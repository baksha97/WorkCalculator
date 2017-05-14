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
    
    var organization: String!
    var type: WorkDayType!
    var timestamp: String!
    var store_startTime: String?
    var store_endTime: String?
    var delivery_startTime: String?
    var delivery_endTime: String?
    
    var storeDuration: Double?
    var deliveryDuration: Double?
    
    
    let ref: FIRDatabaseReference?
    
    init(organization: String, store_startTime: Date, store_endTime: Date) {
        self.organization = organization
        self.type = .store
        self.timestamp = store_startTime.stringValue
        self.store_startTime = store_startTime.stringValue
        self.store_endTime = store_endTime.stringValue
        
        self.storeDuration = store_startTime.minutes(to: store_endTime).rounded(toPlaces: 0)
        
        self.ref = nil
    }
    
    init(organization: String, delivery_startTime: Date, delivery_endTime: Date) {
        self.organization = organization
        self.type = .delivery
        self.timestamp = delivery_startTime.stringValue
        self.delivery_startTime = delivery_startTime.stringValue
        self.delivery_endTime = delivery_endTime.stringValue
        
        self.deliveryDuration = delivery_startTime.minutes(to: delivery_endTime).rounded(toPlaces: 0)
        
        self.ref = nil
    }
    
    init(organization: String, store_startTime: Date, store_endTime: Date, delivery_startTime: Date, delivery_endTime: Date) {
        self.organization = organization
        self.type = .storeAndDelivery
        self.timestamp = store_startTime.stringValue
        self.store_startTime = store_startTime.stringValue
        self.store_endTime = store_endTime.stringValue
        self.delivery_startTime = delivery_startTime.stringValue
        self.delivery_endTime = delivery_endTime.stringValue
        
        self.storeDuration = store_startTime.minutes(to: store_endTime).rounded(toPlaces: 0)
        self.deliveryDuration = delivery_startTime.minutes(to: delivery_endTime).rounded(toPlaces: 0)
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        organization = snapshotValue["organization"] as! String
        type = WorkDayType(rawValue: snapshotValue["type"] as! String)
        timestamp = snapshotValue["timestamp"] as! String
        store_startTime = snapshotValue["store-start"] as? String
        store_endTime = snapshotValue["store-end"] as? String
        delivery_startTime = snapshotValue["delivery-start"] as? String
        delivery_endTime = snapshotValue["delivery-end"] as? String
        
        storeDuration = (snapshotValue["store-start"] as? String)?.dateValue?.minutes(to: ((snapshotValue["store-end"] as? String)?.dateValue)!).rounded(toPlaces: 0)
        deliveryDuration = (snapshotValue["delivery-start"] as? String)?.dateValue?.minutes(to: ((snapshotValue["delivery-end"] as? String)?.dateValue)!).rounded(toPlaces: 0)

        ref = snapshot.ref
        
        if store_startTime != nil  && delivery_startTime == nil{
            type = .store
        }
        if store_startTime == nil  && delivery_startTime != nil{
            type = .delivery
        }
        if store_startTime != nil  && delivery_startTime != nil{
            type = .storeAndDelivery
        }
        
    }
    
    func toAnyObject() -> Any {
        return [
            "organization":organization,
            "type":type.description,
            "timestamp":timestamp,
            "store-start":store_startTime as Any,
            "store-end":store_endTime as Any,
            "delivery-start":delivery_startTime as Any,
            "delivery-end":delivery_endTime as Any,
            "store-duration":storeDuration as Any,
            "delivery-duration":deliveryDuration as Any
        ]
    }
    
    var description: String{
        var text = "";
        
        switch self.type! {
            case .store:
                text += "\n" + self.organization
                text += "\n Store: " + (self.store_startTime?.dateValue?.hoursString)! + " - " + (self.store_endTime?.dateValue?.hoursString)!
            case .delivery:
                text += "\n" + self.organization
                text += "\n Delivery: " + (self.delivery_startTime?.dateValue?.hoursString)! + " - " + (self.delivery_endTime?.dateValue?.hoursString)!
            case .storeAndDelivery:
                text += "\n" + self.organization
                text += "\n Store: " + (self.store_startTime?.dateValue?.hoursString)! + " - " + (self.store_endTime?.dateValue?.hoursString)!
                text += "\n Delivery: " + (self.delivery_startTime?.dateValue?.hoursString)! + " - " + (self.delivery_endTime?.dateValue?.hoursString)!
            default:
                break
        }
        return text
    }
    
    /*
    public func toString() -> String{
        var s: String = ""
        s += "\n" + self.organization
        s += "\n Store: " + (self.store_startTime?.dateValue?.hoursString)! + " - " + (self.store_endTime?.dateValue?.hoursString)!
        return s
    }*/
}

enum WorkDayType {
    case store, delivery, storeAndDelivery, error
    
    init(rawValue: String) {
        switch rawValue {
        case "Store": self = .store
        case "Delivery": self = .delivery
        case "Store and Delivery": self = .storeAndDelivery
        default: self = .error // bad
        }
    }
 
    var description: String{
        switch(self){
        case .store:
            return "Store"
        case .delivery:
            return "Delivery"
        case .storeAndDelivery:
            return "Store and Delivery"
        case .error:
            return "Error initializing type..."
        }
    }
}


