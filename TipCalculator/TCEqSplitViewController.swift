//
//  TCEqSplitViewController.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/10/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

class TCEqSplitViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

   
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
    @IBOutlet weak var totalPerPerson: UITextField!
    @IBOutlet weak var tipPerPerson: UITextField!
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    @IBAction func doCalculate(sender: AnyObject) {
        
        calculateResults()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        TCHelperClass.isFirstVC = true
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //initially hide Results
        bottomView.alpha = 0
        
        //Set Master Data
        TCMasterData.setGuestValues()
        TCMasterData.setTipValues()
        
        //Text Field Delegates
        numGuests.delegate = self
        tipPercent.delegate = self
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self
        numGuestpickerView.backgroundColor = TCMasterData.pickerBkgColor
       

        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self
        tipPercentpickerView.backgroundColor = TCMasterData.pickerBkgColor
        
        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        // Done button on keyboard
        TCHelperClass.addDoneButtonOnKeyboard(self, sendingTextFld: billAmount)
        
        //Tap gesture recognizer to dismiss Keyboard and Picker View
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    

    
    func calculateResults() {
        
        //resign first responder
        dismissKeyboard()
        
        //calculate results only if key values are populated
        if let numGuests = TCMasterData.guest_to_num_converter[numGuests.text!],
            tipPercent = TCMasterData.tip_to_num_converter[tipPercent.text!],
            billAmount = Double(billAmount.text!){
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            totalTipToPay.text = String(format: "%.2f", TCHelperClass.getTotalTip())
            
            totalToPay.text =  String(format: "%.2f", billAmount + TCHelperClass.getTotalTip())
            
            tipPerPerson.text = String(format: "%.2f", TCHelperClass.getPerPersonTip() )
            
            totalPerPerson.text = String(format: "%.2f", TCHelperClass.getPerPersonAmount() + TCHelperClass.getPerPersonTip())
            
            
            //show the results if bottom view is hidden
            if self.bottomView.alpha == 0.0 {
                UIView.animateWithDuration(TCMasterData.animationDuration) {
                    self.bottomView.alpha = 1.0
                }
            }
            
        } else {
            
            // make all key fields blank
            numGuests.text = ""
            tipPercent.text = ""
            billAmount.text = ""
            
            //hide the bottom view
            if self.bottomView.alpha == 1.0 {
                
                UIView.animateWithDuration(TCMasterData.animationDuration) {
                    self.bottomView.alpha = 0.0
                }
                
            }
            
        }
        
        
    }


}

// MARK: Resign first responder Logic
extension TCEqSplitViewController{
 
    func doneButtonAction()
    {
        billAmount.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}

// MARK: Picker View logic
extension TCEqSplitViewController{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        //For example, if you wanted to do a picker for selecting time,
        //you might have 3 components; one for each of hour, minutes and seconds
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numGuestpickerView{
            
            return TCMasterData.guests.count
        }
        else {
            return TCMasterData.tips.count
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == numGuestpickerView{
            
            return TCMasterData.guests[row]
        }
        else {
            
            return TCMasterData.tips[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        pickerView.reloadAllComponents()
        
        if pickerView == numGuestpickerView{
            
            numGuests.text = TCMasterData.guests[row]
            
        } else {
            
            tipPercent.text =  TCMasterData.tips[row]
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let color = (row == pickerView.selectedRowInComponent(component)) ? UIColor.whiteColor() : UIColor.grayColor()
        
        if pickerView == numGuestpickerView{
            return NSAttributedString(string: TCMasterData.guests[row], attributes: [NSForegroundColorAttributeName: color])
        } else {
            return NSAttributedString(string: TCMasterData.tips[row], attributes: [NSForegroundColorAttributeName: color])
        }
    }
 
  
    
}

//MARK: UITextFieldDelegate implementation
extension TCEqSplitViewController {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "" {
            
            if textField == numGuests {
                
                numGuests.text = TCMasterData.guests[numGuestpickerView.selectedRowInComponent(0)]
                
            }
            if textField == tipPercent {
                
                tipPercent .text = TCMasterData.tips[tipPercentpickerView.selectedRowInComponent(0)]
            }
        }
    
    
    }
    
}
