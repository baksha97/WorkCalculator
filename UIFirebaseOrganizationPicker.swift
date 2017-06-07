//
//  UIFirebaseOrganizationPicker.swift
//  WorkCalculator
//
//  Created by Loaner on 5/16/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UIFirebaseOrganizationPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var picks: [String] = ["Medicine Cabinet"]
    var selectedOption: String = ""
    let orgRef = FIRDatabase.database().reference(withPath: "organizations/")
    
    var textField = UITextField()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedOption = picks.first!
        textField.text = selectedOption
        delegate = self
        dataSource = self
        textField.inputView = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.58, green:0.00, blue:0.00, alpha:1.0)
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismiss))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                    target: nil,
                                    action: nil);
        toolBar.setItems([space, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        
        self.orgRef.observe( .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let organizations = value?["list"] as! [String]
            self.picks = organizations
            })
    }
    
    func setSelectedOption(index: Int){
        selectedOption = picks[index]
    }
    
    //MARK: TEXTFIELD FUNCTIONS
    func textFieldDidBeginEditing(textField: UITextField!){
        self.textField = textField
    }
    
    class func defaultPicker() -> UIFirebaseOrganizationPicker{
        let picker = UIFirebaseOrganizationPicker()
        
        picker.setSelectedOption(index: 0)
        picker.delegate = picker
        picker.dataSource = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: picker, action: #selector(dismiss))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                    target: nil,
                                    action: nil);
        toolBar.setItems([space, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        picker.textField.inputAccessoryView = toolBar
        return picker
    }
    
    func dismiss(){
        textField.inputView?.endEditing(true)
        //textField.endEditing(true)
    }
    
    /*/MARK: ALERTVIEW FUNCTION
    
    func userFirebaseActionSheet(_ sender: SettingsViewController){
        let title = "Desired LifeStyle"
        let message = " \n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect(x: 12, y: 15, width: 330, height: 160); // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: DesiredLifestylePicker = DesiredLifestylePicker(frame: pickerFrame);
        picker.awakeFromNib()
        alert.view.addSubview(picker);
        
        
        let saveAction = UIAlertAction(title: "Save Style?", style: .default){
            (action: UIAlertAction) in
            
            let id: String = Util.removePeriod(s: (sender.user?.email)!)
            sender.rootRef.child("users//\(id)/User-Data/desired-lifestyle").setValue(picker.selectedOption)
            
        }
        let cancelAction = UIAlertAction(title:"Cancel",  style: .cancel){
            (action:UIAlertAction) in
            return
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        sender.present(alert, animated: true, completion: nil);
    }
    
    */
    //MARK: PICKER FUNCTIONS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.setSelectedOption(index: row)
        textField.text = selectedOption
    }
}
