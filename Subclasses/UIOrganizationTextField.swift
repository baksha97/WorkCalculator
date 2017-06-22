//
//  UIOrganizationTextField.swift
//  WorkCalculator
//
//  Created by Loaner on 5/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit

class UIOrganizationTextField: UITextField, UITextFieldDelegate {
    
    let picker = UIFirebaseOrganizationPicker.defaultPicker()
    
    var organization: String{
        get{
            if(self.text == ""){
                fatalError("Organization cannot be empty!!!!!!")
            }
            else{
                return picker.selectedOption
            }
        }
        set(value){
            picker.selectedOption = value
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
        text = picker.selectedOption
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
