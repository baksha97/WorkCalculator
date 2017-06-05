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

    let workDayViewSegue = "cellToDisplay"
    
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
            self.tableView.reloadData()
        })
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workDays.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkDayTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkDayTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkDayTableViewCell.")
        }
        
        // Fetches the appropriate run for the data source layout.
        let day = workDays[indexPath.row]
        
        cell.companyLabel.text = day.organization
        cell.dateLabel.text = day.timestamp.dateValue?.longDescription
        print(day.description)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let day = workDays[indexPath.row]
            day.ref?.removeValue()
            self.tableView.reloadData()
        }
    }
    
    private func load(){
        let dayRef = FIRDatabase.database().reference(withPath: "users//\(rUser.userRef)/Workdays/")
        dayRef.observe(.value, with: { snapshot in
            var currentWorkDays = [WorkDay]()
            for day in snapshot.children{
                let oldDay = WorkDay(snapshot: day as! FIRDataSnapshot)
                currentWorkDays.append(oldDay)
            }
            currentWorkDays.sort(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
            self.workDays = currentWorkDays;
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: workDayViewSegue, sender: indexPath);
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == workDayViewSegue {
            let nextView = segue.destination as! WorkDayViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let displayDay = workDays[indexPath.row]
                nextView.displayDay = displayDay
            }
        }
    }
    

}
