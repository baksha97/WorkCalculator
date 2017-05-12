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

    @IBOutlet weak var lb: UILabel!
    @IBOutlet weak var tf: UIDateTextField!
    @IBOutlet weak var tf2: UIDateTextField!
    
    
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func watButton(_ sender: Any) {
        
        let wd: WorkDay = WorkDay(store_startTime: tf.date, store_endTime: tf2.date)
        self.ref.child("users/\(rUser.userRef)/Workdays/\(tf.date.firebaseTitle)").setValue(wd.toAnyObject())
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
