//
//  WorkDayTableViewCell.swift
//  WorkCalculator
//
//  Created by Loaner on 5/12/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

class WorkDayTableViewCell: UITableViewCell {

    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
