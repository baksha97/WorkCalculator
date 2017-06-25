//
//  DisplayAllWorkDaysViewController.swift
//  WorkCalculator
//
//  Created by Loaner on 5/13/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class DisplayAllWorkDaysViewController: UIViewController{
    
    let storeRate = 11.0
    let deliveryRate = 15.0

    @IBOutlet weak var displayTextField: UITextView!
    
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    //MARK: Array of WorkDays
    var workDays = [WorkDay]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userRef = FIRDatabase.database().reference(withPath: "users/\(rUser.userRef))/")
        
        userRef.observe(.value, with: { snapshot in
            self.load()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func load(){
        let runRef = FIRDatabase.database().reference(withPath: "users//\(rUser.userRef)/Workdays/")
        runRef.observe(.value, with: { snapshot in
            var currentWorkDays = [WorkDay]()
            for day in snapshot.children{
                let oldDay = WorkDay(snapshot: day as! FIRDataSnapshot)
                currentWorkDays.append(oldDay)
            }
            currentWorkDays.sort(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
            self.workDays = currentWorkDays;
            self.configureView()
        })
    }
    
    private func configureView(){
        /* OLD WAY
        displayTextField.text = ""
        
        for day in workDays{
            displayTextField.text = displayTextField.text + "\n" + day.description
            displayTextField.text.append("\n")
        }
        
        let (storeD, deliveryD) = WorkDay.totalDurations(arrayOfDays: workDays)
        
        displayTextField.text = displayTextField.text + "\n\n Store Total: \(storeD.minuteToHours) \n Delivery Total: \(deliveryD.minuteToHours)"
         */
        
        displayTextField.text = ""
        
        for (i, day) in workDays.enumerated(){
            if(workDays[i+1].timestamp.dateValue?.shortDescription == day.timestamp.dateValue?.shortDescription){
                
            }
            displayTextField.text = displayTextField.text + "\n" + day.description
            displayTextField.text.append("\n")
        }
        
        let (storeD, deliveryD) = WorkDay.totalDurations(arrayOfDays: workDays)
        
        displayTextField.text = displayTextField.text + "\n\n Store Total: \(storeD.minuteToHours) \n Delivery Total: \(deliveryD.minuteToHours)"
        
 
 
    }
    
    @IBAction func payDidTouch(_ sender: Any) {
        let (storeD, deliveryD) = WorkDay.totalDurations(arrayOfDays: workDays)
        let storeEarnings = storeD.minuteToHours*storeRate
        let deliveryEarnings = deliveryD.minuteToHours*deliveryRate
        let total = storeEarnings + deliveryEarnings
        
        let alert = UIAlertController(title: "Your payment calculations...",
                                      message: "Store Hours: \(storeD.minuteToHours) \nDelivery Hours: \(deliveryD.minuteToHours) \n\n Store Earnings \(storeEarnings) \n Delivery Earnings \(deliveryEarnings) \n\n Total Earnings: \(total)",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay",
                                     style: .default){ action in
                                        
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareDidClick(_ sender: Any) {
        // text to share
        let text = displayTextField.text
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.setValue("subject test", forKey: "subject")
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
