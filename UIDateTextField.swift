//
//  UIDateTextField.swift
//  WorkCalculator
//
//  Created by Loaner on 5/11/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

import UIKit  // don't forget this

class UIDateTextField: UITextField, UITextFieldDelegate {
    
    var date = Date()
    let picker = DateTimePicker.setDefault()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.inputView = picker
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa MM/dd/YYYY"
            self.date = date
            print(self.date.stringValue!)
            self.text = formatter.string(from: date)
        }
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(paste(_:)) || action == #selector(cut(_:)) ||
            action == #selector(delete(_:)) || action == #selector(delete(_:)) ||
            action == #selector(replace(_:withText:))){
            return false
        }
        return true
    }
    
}
