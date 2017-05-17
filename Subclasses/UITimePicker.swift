//
//  UI.swift
//  WorkCalculator
//
//  Created by Loaner on 5/15/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import Foundation

import UIKit

class UITimePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let segments = (hours: (Array(0...10).map{Int($0)}), ["hours"], minutes: (Array(0...59).map{Int($0)}), ["mins"])
    
    var selectedOption: Int = 0
    
    var textField = UITextField()
    
    class func defaultPicker() -> UITimePicker{
        let picker = UITimePicker()
        
        picker.setSelected(wholeIndex: 0, decimalIndex: 0)
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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelected(wholeIndex: 0, decimalIndex: 0)
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
        
        
        ///
        
        let height = CGFloat(20)
        let offsetX = self.frame.size.width / 3
        let offsetY = self.frame.size.height/2 - height/2
        let marginX = CGFloat(42)
        let width = offsetX - marginX
        
        let hourLabel = UILabel(frame: CGRectMake(marginX, offsetY, width, height))
        hourLabel.text = "hour"
        self.addSubview(hourLabel)
        
        let minsLabel = UILabel(frame: CGRectMake(marginX + offsetX, offsetY, width, height))
        minsLabel.text = "min"
        self.addSubview(minsLabel)
        
        
    }
    
    func dismiss(){
        textField.endEditing(true)
    }
    
    
    
    func setSelected(wholeIndex: Int, decimalIndex: Int){
        let minutes = (segments.hours[wholeIndex]*60) + segments.minutes[decimalIndex]
        selectedOption = minutes
    }
    
    //MARK: PICKER FUNCTIONS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return segments.0.count
        }else if component == 1 {
            return segments.1.count
        }else if component == 2{
            return segments.2.count
        }else{
            return segments.3.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
      /*  if component == 0 {
            return String(segments.0[row])
        }else if component == 1 {
            return String(segments.1[row])
        }else if component == 2{
            return String(segments.2[row])
        }else if component == 3{
            return String(segments.3[row])
        } */
        return "error"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let whole = pickerView.selectedRow(inComponent: 0)
        let decimal = pickerView.selectedRow(inComponent: 2)
        
        setSelected(wholeIndex: whole, decimalIndex: decimal)
        textField.text = String(selectedOption) + " minutes"
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

