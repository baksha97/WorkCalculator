//
//  DisplayAllWorkDaysViewController.swift
//  WorkCalculator
//
//  Created by Loaner on 5/13/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class DisplayAllWorkDaysViewController: UIViewController {

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
         displayTextField.text = ""
        
        for day in workDays{
            displayTextField.text = displayTextField.text + "\n" + day.description
        }
    }

}
