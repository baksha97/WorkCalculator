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
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var loadButton: UIButton!
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    var stringOfDays: [String] = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.companyTextField.text = "Medicine Cabinet"
        configureTextFields()
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
    
    
    private func saveInputToFirebase(from startingTextField: UIDateTextField){
        var input = [String]()
        
        var current: UIDateTextField = startingTextField
        
        while(!current.hasNoText){
            input.append(current.picker.selectedDate.stringValue!)
            current = (current.endField)!
        }
        if(!startingTextField.hasNoText){
            self.ref.child("users/\(rUser.userRef)/unsaved-workday/current/").setValue(input)
        }
    }
    
    func switchWorkDayType(storeTextField: UIDateTextField, deliveryTextField: UIDateTextField){
        
    }
    
    @IBAction func saveDidTouch(_ sender: Any) {
        saveInputToFirebase(from: tf)
    }
    
    @IBAction func loadDidTouch(_ sender: Any) {
        /*
        self.ref.child("users/\(rUser.userRef)/unsaved-workday/current/").observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                print(value)
            })
        */
        
       // breakDuration = snapshotValue["break-duration"] as? Double
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
