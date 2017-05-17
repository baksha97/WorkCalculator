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
    @IBOutlet var breakTextField: UITimeTextField!
    
    @IBOutlet weak var dtf: UIDateTextField!
    @IBOutlet weak var dtf2: UIDateTextField!
    
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.companyTextField.text = "Medicine Cabinet"
    }
    
    private func configureTextFields(){
        tf.endField = tf2
        tf2.endField = dtf
        dtf.endField = dtf2
    }
    
    @IBAction func watButton(_ sender: Any) {
    
        if(tf.isEmpty == true && dtf.isEmpty == false){
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, delivery_startTime: dtf.date, delivery_endTime: dtf2.date)
            self.ref.child("users/\(rUser.userRef)/Workdays/\(dtf.date.firebaseTitle)").setValue(wd.toAnyObject())
            
        }
        else if(dtf.isEmpty == true && tf.isEmpty == false){
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, store_startTime: tf.date, store_endTime: tf2.date, breakDuration: (Double(breakTextField.value)))
            self.ref.child("users/\(rUser.userRef)/Workdays/\(tf.date.firebaseTitle)").setValue(wd.toAnyObject())
        }
        else if(tf.isEmpty == true && dtf.isEmpty == true){
           print(".isEmpty = true")
        }
        else{
            let wd: WorkDay = WorkDay(organization: companyTextField.text!, store_startTime: tf.date, store_endTime: tf2.date, delivery_startTime: dtf.date, delivery_endTime: dtf2.date, breakDuration: (Double(breakTextField.value)))
            self.ref.child("users/\(rUser.userRef)/Workdays/\(tf.date.firebaseTitle)").setValue(wd.toAnyObject())
        }
        
    }
    
    func switchWorkDayType(storeTextField: UIDateTextField, deliveryTextField: UIDateTextField){
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
