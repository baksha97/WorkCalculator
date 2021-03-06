//
//  PastWorkDaysTableViewController.swift
//  WorkCalculator
//
//  Created by Loaner on 5/12/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class PastWorkDaysTableViewController: UITableViewController {
    
    let selectedDaysSegue = "pastToSelectedDays"
    
    //MARK: Outlets
    @IBOutlet var leftButton: UIBarButtonItem!
    @IBOutlet var rightButton: UIBarButtonItem!
    @IBOutlet var organizationTextField: UIOrganizationTextField!
    

    let workDayViewSegue = "cellToDisplay"
    
    //MARK: FIREBASE
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    let rUser = UserData(authData: (Auth.auth().currentUser)!)
    
    //MARK: Array of WorkDays
    var selectedDays = [WorkDay]() // for segue
    var segmentedWorkDays = [[WorkDay]]()
    var segmentedTitles = [Date]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userRef = Database.database().reference(withPath: "users/\(rUser.userRef))/")
        
        userRef.observe(.value, with: { snapshot in
            self.load()
          //  self.tableView.reloadData()
        })
        organizationTextField.text = "Displaying all days"
    }
    
    private func reconfigureNavigationButtons(){
        //selected clicked
        if(leftButton.title == "Select"){
            
            //left button changes
            leftButton.title = "Cancel"
            leftButton.tintColor = UIColor.red
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.setEditing(true, animated: false)
            
            //right button changes
            rightButton.title = "Send"
        }
            //cancel clicked
        else if(leftButton.title == "Cancel"){
            //left button changes
            leftButton.title = "Select"
            leftButton.tintColor = self.view.tintColor
            tableView.allowsMultipleSelectionDuringEditing = false
            tableView.setEditing(false, animated: true)
            
            //right button changes
            rightButton.title = "+"
            
            //reset selected days
            selectedDays = [WorkDay]()
        }
    }
    
    
    @IBAction func leftDidTouch(_ sender: Any) {
        reconfigureNavigationButtons()
        
    }
    
    @IBAction func rightDidTouch(_ sender: Any) {
        //adding a new day
        if(rightButton.title == "+"){
            print("TODO: Add a way to add a new workday with this button")
        }
        else if(rightButton.title == "Send"){
            if selectedDays.first != nil{
                self.performSegue(withIdentifier: selectedDaysSegue, sender: nil)
            }
        }
    }
    
    @IBAction func editingEnd(_ sender: Any) {
        changeOrganization(newOrganization: organizationTextField.organization)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == selectedDaysSegue{
            let nextView = segue.destination as! SelectedDatesTableViewController
            selectedDays.sort(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending});           nextView.workDays = selectedDays
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        /*
        print("sWD.count: \(segmentedWorkDays.count)")
        print("sT.count: \(segmentedTitles.count)")
        */
        return segmentedTitles.count//segmentedWorkDays.count
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return segmentedWorkDays[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return segmentedTitles[section].longDescription //segmentedWorkDays[section].first?.timestamp.dateValue?.mediumDescription ?? "Error loading title for this segment [nil]"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkDayTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkDayTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkDayTableViewCell.")
        }
        
        // Fetches the appropriate run for the data source layout.
        let day = segmentedWorkDays[indexPath.section][indexPath.row]
        
        cell.descriptionTextField.text = day.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let day = segmentedWorkDays[indexPath.section][indexPath.row]
            day.ref?.removeValue()
            self.tableView.reloadData()
        }
    }
    
    private func load(){
        let dayRef = Database.database().reference(withPath: "users//\(rUser.userRef)/Workdays/")
        dayRef.observe(.value, with: { snapshot in
            var currentWorkDays = [WorkDay]()
            for day in snapshot.children{
                let oldDay = WorkDay(snapshot: day as! DataSnapshot)
                currentWorkDays.append(oldDay)
            }
            currentWorkDays.sort(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
        //    self.workDays = currentWorkDays
            
            let (anchors, segementedWorkdays) = WorkDay.customBiWeeklyAnchor(from: currentWorkDays)
            
            self.segmentedWorkDays = segementedWorkdays
            self.segmentedTitles = anchors
            
            self.tableView.reloadData()
        })
    }
    
    private func changeOrganization(newOrganization: String){
        let dayRef = Database.database().reference(withPath: "users//\(rUser.userRef)/Workdays/")
        dayRef.observe(.value, with: { snapshot in
            var currentWorkDays = [WorkDay]()
            for day in snapshot.children{
                let oldDay = WorkDay(snapshot: day as! DataSnapshot)
                currentWorkDays.append(oldDay)
            }
            currentWorkDays.sort(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
            
            
            var selectedCompanyDays = [WorkDay]()
            for (_, day) in currentWorkDays.enumerated(){
                if day.organization == newOrganization{
                    selectedCompanyDays.append(day)
                }
            }
            
            let (anchors, segementedWorkdays) = WorkDay.customBiWeeklyAnchor(from: selectedCompanyDays)
            
            self.segmentedWorkDays = segementedWorkdays
            self.segmentedTitles = anchors
            
            self.tableView.reloadData()
        })
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEditing == true){
            selectedDays.append(segmentedWorkDays[indexPath.section][indexPath.row])
        }
        else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (tableView.isEditing == true){
            for (index, day) in selectedDays.enumerated() {
                if (day.timestamp.dateValue?.longDescription)! == (segmentedWorkDays[indexPath.section][indexPath.row]).timestamp.dateValue!.longDescription {
                    selectedDays.remove(at: index)
                    break
                }
            }
        }
        else{
            
        }
    }
    
    
    

}
