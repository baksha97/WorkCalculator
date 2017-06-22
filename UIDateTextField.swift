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
    
    var endField: UIDateTextField?
    
    var hasPickerDate: Bool?
    
    var date = Date()
    let picker = DateTimePicker.setDefault()
    
    var isEmpty: Bool!{
        if self.text == "" || self.endField!.text == "" {
            return true
        }
        else{
            return false
        }
    }
    
    var hasNoText: Bool{
        if self.text == ""{
            return true
        }
        else{
            return false
        }
    }
    
    public func loadDate(date: Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a." /// this is a very expensive operation :/
        
        self.date = date
        self.picker.selectedDate = date
        self.text = formatter.string(from: date)
        self.endField?.picker.selectedDate = date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.text = ""
        self.hasPickerDate = nil
        self.inputView = picker
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a."
            self.date = date
            self.endField?.picker.selectedDate = date
            self.text = formatter.string(from: date)
            self.hasPickerDate = true
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
