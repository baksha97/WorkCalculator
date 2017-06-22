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
    @IBOutlet var companyTextField: UIOrganizationTextField!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTextFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func configureTextFields(){
        WorkDay.configureFields(storeStart: tf, storeEnd: tf2, deliveryStart: dtf, deliveryEnd: dtf2)
        WorkDay.loadWorkdayInProgress(){ (company, storeFields, deliveryFields, breakMin) -> () in
            
            if company != "" && company != nil{
                self.companyTextField.text = company
                self.companyTextField.organization = company!
            }
            
            if let storeFields = storeFields{
                self.loadStoreFieldsFromFirebase(with: storeFields)
            }
            
            if let deliveryFields = deliveryFields{
                self.loadDeliveryFieldsFromFirebase(with: deliveryFields)
            }
            
            if let breakMinutes = breakMin{
                self.breakTextField.value = breakMinutes
                self.breakTextField.text = "\(breakMinutes) minutes"
                
            }
        }
        
    }
    
    @IBAction func watButton(_ sender: Any) {
        if(WorkDay.addToFirebase(companyTextField: companyTextField, storeStart: tf, storeEnd: tf2, breakTextField: breakTextField, deliveryStart: dtf, deliveryEnd: dtf2)){
            clearFields()
        }
    }
    
    
    private func clearFields(){
        tf.awakeFromNib()
        tf2.awakeFromNib()
        dtf.awakeFromNib()
        dtf2.awakeFromNib()
        breakTextField.clear()
    }
    
    private func loadStoreFieldsFromFirebase(with store: [String]?){
        var current = tf
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a."
        
        for dateString in store!{
            current?.loadDate(date: dateString.dateValue!)
            current = current?.endField
        }
    }
    
    private func loadDeliveryFieldsFromFirebase(with delivery: [String]?){
        var current = dtf
        
        for dateString in delivery!{
            current?.loadDate(date: dateString.dateValue!)
            
            current = current?.endField
        }
    }
    
    
    @IBAction func saveDidTouch(_ sender: Any) {
        WorkDay.saveInputToFirebase(companyTextField: companyTextField, storeStart: tf, storeEnd: tf2, breakTextField: breakTextField, deliveryStart: dtf, deliveryEnd: dtf2)
    }
    
    @IBAction func resetProgressDidTouch(_ sender: Any) {
        WorkDay.resetCurrentWorkdayProgress()
        clearFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
