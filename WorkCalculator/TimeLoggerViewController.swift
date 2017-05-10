//
//  TimeLoggerViewController.swift
//  WorkCalculator
//
//  Created by Loaner on 5/10/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class TimeLoggerViewController: UIViewController {

    @IBOutlet weak var dp1: UIDatePicker!
    @IBOutlet weak var dp2: UIDatePicker!
    
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func watButton(_ sender: Any) {
        
        let wd: WorkDay = WorkDay(store_startTime: dp1.date, store_endTime: dp2.date)
        self.ref.child("users/\(rUser.userRef)/Workdays/\(dp1.date.stringValue)").setValue(wd.toAnyObject())
        
    }

    
}
