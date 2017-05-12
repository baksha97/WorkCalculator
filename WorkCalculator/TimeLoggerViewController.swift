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
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var tf: UIDateTextField!
    @IBOutlet weak var tf2: UIDateTextField!
    
    @IBOutlet weak var dtf: UIDateTextField!
    @IBOutlet weak var dtf2: UIDateTextField!
    
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf.endField = tf2
        dtf.endField = dtf2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func watButton(_ sender: Any) {
    
        if(tf.isEmpty == true && dtf.isEmpty == false){
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, delivery_startTime: dtf.date, delivery_endTime: dtf2.date)
            self.ref.child("users/\(rUser.userRef)/Workdays/\(dtf.date.firebaseTitle)").setValue(wd.toAnyObject())
            
        }
        else if(dtf.isEmpty == true && tf.isEmpty == false){
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, store_startTime: tf.date, store_endTime: tf2.date)
            self.ref.child("users/\(rUser.userRef)/Workdays/\(tf.date.firebaseTitle)").setValue(wd.toAnyObject())
        }
        else{
            print(".isEmpty = true")
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
