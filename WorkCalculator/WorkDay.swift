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
    var breakDuration: Double?
    
    
    let ref: FIRDatabaseReference?
    
    init(organization: String, store_startTime: Date, store_endTime: Date, breakDuration: Double = 0) {
        self.organization = organization
        self.type = .store
        self.timestamp = store_startTime.stringValue
        self.store_startTime = store_startTime.stringValue
        self.store_endTime = store_endTime.stringValue
        
        self.storeDuration = store_startTime.minutes(to: store_endTime).rounded(toPlaces: 0) - breakDuration
        self.breakDuration = breakDuration
        
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
    
    init(organization: String, store_startTime: Date, store_endTime: Date, delivery_startTime: Date, delivery_endTime: Date, breakDuration: Double = 0) {
        self.organization = organization
        self.type = .storeAndDelivery
        self.timestamp = store_startTime.stringValue
        self.store_startTime = store_startTime.stringValue
        self.store_endTime = store_endTime.stringValue
        self.delivery_startTime = delivery_startTime.stringValue
        self.delivery_endTime = delivery_endTime.stringValue
        
        self.storeDuration = store_startTime.minutes(to: store_endTime).rounded(toPlaces: 0) - breakDuration
        self.breakDuration = breakDuration
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
        
        breakDuration = snapshotValue["break-duration"] as? Double
        deliveryDuration = (snapshotValue["delivery-start"] as? String)?.dateValue?.minutes(to: ((snapshotValue["delivery-end"] as? String)?.dateValue)!).rounded(toPlaces: 0)

        ref = snapshot.ref
        
        if (type! == .store) || (type! == .storeAndDelivery){
            storeDuration = ((((snapshotValue["store-start"] as? String)?.dateValue?.minutes(to: ((snapshotValue["store-end"] as? String)?.dateValue)!).rounded(toPlaces: 0)))! - breakDuration!)
        }
        
        
        /*
        if store_startTime != nil  && delivery_startTime == nil{
            type = .store
        }
        if store_startTime == nil  && delivery_startTime != nil{
            type = .delivery
        }
        if store_startTime != nil  && delivery_startTime != nil{
            type = .storeAndDelivery
        }
        */
    }
    
    func toAnyObject() -> Any {
        return [
            "organization":organization,
            "type":type.description,
            "timestamp":timestamp,
            "store-start":store_startTime as Any,
            "store-end":store_endTime as Any,
            "break-duration":breakDuration as Any,
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
                text += self.organization
                text += " - \(self.timestamp.dateValue!.mediumDescription)"
                text += "\n Store: " + (self.store_startTime?.dateValue?.hoursString)! + " - " + (self.store_endTime?.dateValue?.hoursString)!
                text += "\n Store Duration: \(self.storeDuration!.minuteToHours) hours, [Break: \(self.breakDuration!) mins]"
            case .delivery:
                text += self.organization
                text += " - \(self.timestamp.dateValue!.mediumDescription)"
                text += "\n Delivery: " + (self.delivery_startTime?.dateValue?.hoursString)! + " - " + (self.delivery_endTime?.dateValue?.hoursString)!
                text += "\n Delivery Duration: \(self.deliveryDuration!.minuteToHours) hours"
            case .storeAndDelivery:
                text += self.organization
                text += " - \(self.timestamp.dateValue!.mediumDescription)"
                text += "\n Store: " + (self.store_startTime?.dateValue?.hoursString)! + " - " + (self.store_endTime?.dateValue?.hoursString)!
                text += "\n Store Duration: \(self.storeDuration!.minuteToHours) hours, [Break: \(self.breakDuration!) mins]"
                text += "\n Delivery: " + (self.delivery_startTime?.dateValue?.hoursString)! + " - " + (self.delivery_endTime?.dateValue?.hoursString)!
                text += "\n Delivery Duration: \(self.deliveryDuration!.minuteToHours) hours"
            default:
                break
        }
        
        return text
    }
    
    
    static func totalDurations(arrayOfDays days: [WorkDay]) -> (Double, Double) {
        
        var totalStore: Double = 0
        var totalDelivery: Double = 0
        
        for day in days{
            switch day.type!{
            case .store:
                totalStore += day.storeDuration!
            case .delivery:
                totalDelivery += day.deliveryDuration!
            
            case .storeAndDelivery:
                totalStore += day.storeDuration!
                totalDelivery += day.deliveryDuration!
            default:
                break
            }
        }
        
        return (store: totalStore, delivery: totalDelivery)
    }
    
    static func customBiWeeklyAnchor(from days: [WorkDay]) -> ([Date], [[WorkDay]]){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd yyyy"
        let anchor = dateFormatter.date(from: "04 23 2017")
        
        return biweeklyAnchorsAndSegments(startAnchor: anchor!, days: days)
    }
    
    static func biweeklyAnchorsAndSegments(startAnchor: Date, days: [WorkDay]) -> (anchors: [Date], segmentedWorkDays: [[WorkDay]]){
        
        //
        let sortedDays = days.sorted(by: {$0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
        var segmentedWorkDays: [[WorkDay]] = [[WorkDay]]()
        segmentedWorkDays.append([WorkDay]())
        
        var indexArray = 0
        var anchorIndex = 0
        //
        
        var anchors: [Date] = [Date]()
        var anchor = startAnchor
        
        for day in sortedDays{
            
            if(day.timestamp.dateValue! < anchor){
                continue
            }
            
            while(day.timestamp.dateValue! > anchor){
                anchor = anchor.twoWeeksLater
            }
            
            anchors.append(anchor.twoWeeksAgo)
            
            
        }
        
        
        for day in sortedDays{
            
            if day.timestamp.dateValue! < anchors[anchorIndex].twoWeeksLater{// && anchorIndex < anchors.count - 1 {
                segmentedWorkDays[indexArray].append(day)
            }
            else if day.timestamp.dateValue! >= anchors[anchorIndex].twoWeeksLater  {
                
                segmentedWorkDays.append([WorkDay]())
                indexArray += 1
                
                segmentedWorkDays[indexArray].append(day)
                
                anchorIndex += 1
            }
            else{
                print("Error creating segments in Workday.getBiWeeklySegments")
            }
            
        }
        
        return (anchors, segmentedWorkDays)
    }
    
    public func AVLTreeDates(from workDays: [WorkDay]) -> AVLTree<Date, String>{
        let tree = AVLTree<Date, String>()
        
        for day in workDays{
            tree.insert(key: day.timestamp.dateValue!, payload: day.timestamp.dateValue?.longDescription)
        }
        
        return tree
    }

    /*
    static func getBiWeeklySegments(from workDay: [WorkDay]) -> (anchors: [Date], workDays: [[WorkDay]]){
        
        let sortedDays = workDay.sorted(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
        var segmentedWorkDays: [[WorkDay]] = [[WorkDay]]()
        segmentedWorkDays.append([WorkDay]())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd yyyy"
        let anchor = dateFormatter.date(from: "04 23 2017")
        let anchors = getBiWeeklyAnchors(startAnchor: anchor!, days: sortedDays)
        
        
        let startingDaySegment = anchors.first
        var endingDaySegment = startingDaySegment?.twoWeeksLater
        
        var indexArray = 0
        
        
        for (_, day) in sortedDays.enumerated(){
        
            if day.timestamp.dateValue! < endingDaySegment! {
                segmentedWorkDays[indexArray].append(day)
            }
            else if day.timestamp.dateValue! >= endingDaySegment! {
                segmentedWorkDays.append([WorkDay]())
                indexArray += 1
                
                segmentedWorkDays[indexArray].append(day)
                
                endingDaySegment = endingDaySegment!.twoWeeksLater
            }
            else{
                print("Error creating segments in Workday.getBiWeeklySegments")
            }
            
        }
        
        return (anchors, segmentedWorkDays)
        
    } */
    
    
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


