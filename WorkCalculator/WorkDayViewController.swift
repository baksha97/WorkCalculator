//
//  WorkDayViewController.swift
//  WorkCalculator
//
//  Created by Loaner on 5/12/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

class WorkDayViewController: UIViewController {
    
    var displayDay: WorkDay!
    
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var storeStartLabel: UILabel!
    @IBOutlet weak var storeEndLabel: UILabel!
    @IBOutlet weak var storeDuration: UILabel!
    
    @IBOutlet weak var deliveryStartLabel: UILabel!
    @IBOutlet weak var deliveryEndLabel: UILabel!
    @IBOutlet weak var deliveryDuration: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(displayDay.organization)
        configureView()
        // Do any additional setup after loading the view.
    }


    
    private func configureView() {
        
        organizationLabel.text = displayDay.organization
        dateLabel.text = displayDay.timestamp.dateValue?.firebaseTitle
        
        storeStartLabel.text = displayDay.store_startTime?.dateValue?.firebaseTitle
        storeEndLabel.text = displayDay.store_endTime?.dateValue?.firebaseTitle
        storeDuration.text = String(describing: displayDay.storeDuration ?? 0)
        
        deliveryStartLabel.text = displayDay.delivery_startTime?.dateValue?.firebaseTitle
        deliveryEndLabel.text = displayDay.delivery_endTime?.dateValue?.firebaseTitle
        deliveryDuration.text = String(describing: displayDay.deliveryDuration ?? 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
