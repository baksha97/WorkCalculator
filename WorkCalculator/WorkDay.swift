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
    
    var noTitleDescription: String{
        var text = "";
        
        switch self.type! {
        case .store:
            text += " - \(self.timestamp.dateValue!.mediumDescription)"
            text += "\n Store: " + (self.store_startTime?.dateValue?.hoursString)! + " - " + (self.store_endTime?.dateValue?.hoursString)!
            text += "\n Store Duration: \(self.storeDuration!.minuteToHours) hours, [Break: \(self.breakDuration!) mins]"
        case .delivery:
            text += " - \(self.timestamp.dateValue!.mediumDescription)"
            text += "\n Delivery: " + (self.delivery_startTime?.dateValue?.hoursString)! + " - " + (self.delivery_endTime?.dateValue?.hoursString)!
            text += "\n Delivery Duration: \(self.deliveryDuration!.minuteToHours) hours"
        case .storeAndDelivery:
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
    
    var firebaseTitle: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a"
        return "\(self.organization!): \(dateFormatter.string(from: timestamp.dateValue!))"
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
    
    static func configureFields(storeStart: UIDateTextField, storeEnd: UIDateTextField, deliveryStart: UIDateTextField, deliveryEnd: UIDateTextField){
        storeStart.endField = storeEnd
        storeEnd.endField = deliveryStart
        deliveryStart.endField = deliveryEnd
    }
    
    static func addToFirebase(companyTextField: UIOrganizationTextField, storeStart: UIDateTextField, storeEnd: UIDateTextField, breakTextField: UITimeTextField, deliveryStart: UIDateTextField, deliveryEnd: UIDateTextField) -> Bool{
        let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
        let ref = FIRDatabase.database().reference()
        
        if(storeStart.isEmpty == true && deliveryStart.isEmpty == false){
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, delivery_startTime: deliveryStart.date, delivery_endTime: deliveryEnd.date)
            ref.child("users/\(rUser.userRef)/Workdays/\(wd.firebaseTitle)").setValue(wd.toAnyObject())
            
        }
        else if(deliveryStart.isEmpty == true && storeStart.isEmpty == false){
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, store_startTime: storeStart.date, store_endTime: storeEnd.date, breakDuration: (Double(breakTextField.value)))
            ref.child("users/\(rUser.userRef)/Workdays/\(wd.firebaseTitle)").setValue(wd.toAnyObject())
        }
        else if(storeStart.isEmpty == true && deliveryStart.isEmpty == true){
            print(".isEmpty = true")
            return false
        }
        else{
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, store_startTime: storeStart.date, store_endTime: storeEnd.date, delivery_startTime: deliveryStart.date, delivery_endTime: deliveryEnd.date, breakDuration: (Double(breakTextField.value)))
            ref.child("users/\(rUser.userRef)/Workdays/\(wd.firebaseTitle)").setValue(wd.toAnyObject())
        }
        self.resetCurrentWorkdayProgress()
        return true
    }
    
    static func saveInputToFirebase(companyTextField: UIOrganizationTextField, storeStart: UIDateTextField, storeEnd: UIDateTextField, breakTextField: UITimeTextField, deliveryStart: UIDateTextField, deliveryEnd: UIDateTextField){
        
        let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
        let ref = FIRDatabase.database().reference()
        
        ref.child("users/\(rUser.userRef)/unsaved-workday/company/").setValue(companyTextField.text)
        
        
        var storeInput = [String]()
        var deliveryInput = [String]()
        
        if(!storeStart.hasNoText){
            storeInput.append(storeStart.date.stringValue!)
            storeInput.append(storeEnd.date.stringValue!)
            ref.child("users/\(rUser.userRef)/unsaved-workday/break-minutes/").setValue(breakTextField.value)
        }
        
        if(!deliveryStart.hasNoText){
            deliveryInput.append(deliveryStart.date.stringValue!)
            deliveryInput.append(deliveryEnd.date.stringValue!)
        }
        
        
        if(!storeStart.hasNoText || !deliveryStart.hasNoText){
            ref.child("users/\(rUser.userRef)/unsaved-workday/store-fields/").setValue(storeInput)
            ref.child("users/\(rUser.userRef)/unsaved-workday/delivery-fields/").setValue(deliveryInput)
        }
    }
    
    static func resetCurrentWorkdayProgress(){
        let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
        let ref = FIRDatabase.database().reference()
        ref.child("users/\(rUser.userRef)/unsaved-workday/").setValue(nil)
    }
    /*
     IN A CLASS USAGE AS A CLASS METHOD!:
     private func configureTextFields(){
        WorkDay.configureFields(storeStart: tf, storeEnd: tf2, deliveryStart: dtf, deliveryEnd: dtf2)
        WorkDay.loadWorkdayInProgress(){ (company, fields, breakMin) -> () in
            if company != "" && company != nil{
                self.companyTextField.text = company
            }
         
            if let dateFields = fields{
                self.loadFieldsFromFirebase(with: dateFields)
            }
            if let breakMinutes = breakMin{
                self.breakTextField.value = breakMinutes
            }
        }
     }
     */
    
    static func loadWorkdayInProgress(completion: @escaping (String?, [String]?, [String]?, Int?) ->()){
        
        let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
        let ref = FIRDatabase.database().reference()
        
        ref.child("users/\(rUser.userRef)/unsaved-workday/").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let company = value?["company"] as? String
            let storeFields = value?["store-fields"] as? [String]
            let deliveryFields = value?["delivery-fields"] as? [String]
            let breakMinutes = value?["break-minutes"] as? Int
            completion(company, storeFields, deliveryFields, breakMinutes)
        })
        
    }
    
    public func AVLTreeDates(from workDays: [WorkDay]) -> AVLTree<Date, String>{
        let tree = AVLTree<Date, String>()
        
        for day in workDays{
            tree.insert(key: day.timestamp.dateValue!, payload: day.timestamp.dateValue?.longDescription)
        }
        
        return tree
    }
    
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


