//
//  UITimeTextField.swift
//  WorkCalculator
//
//  Created by Loaner on 5/15/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit

class UITimeTextField: UITextField, UITextFieldDelegate {
    
    let picker = UITimePicker.defaultPicker()
    
    var value: Int{
        if(self.text == ""){
            return 0
        }
        else{
            return picker.selectedOption
        }
    }
    
    var isEmpty: Bool!{
        if self.text == ""{
            return true
        }
        else{
            return false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.textField = self
        inputView = picker
        picker.awakeFromNib()
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
