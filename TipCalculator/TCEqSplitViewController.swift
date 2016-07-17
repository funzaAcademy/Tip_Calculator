//
//  TCEqSplitViewController.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/10/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

class TCEqSplitViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

   
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
    @IBOutlet weak var totalPerPerson: UITextField!
    @IBOutlet weak var tipPerPerson: UITextField!
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self

        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self

        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        self.addDoneButtonOnKeyboard()
        
    }
    
    func calculateResults() {
        
        if let numGuests = Int(numGuests.text!), tipPercent = Double(tipPercent.text!), billAmount = Double(billAmount.text!){
            totalTipToPay.text = String(round( billAmount * tipPercent / 100 * 100 ) / 100)
            totalToPay.text =  String (round ((billAmount + Double(totalTipToPay.text!)!) * 100 ) / 100 )
            totalPerPerson.text = String ( round ( Double(totalToPay.text!)!/Double(numGuests) * 100.0  ) / 100 )
            tipPerPerson.text = String ( round ( Double(totalTipToPay.text!)!/Double(numGuests) * 100.0  ) / 100 )
     
        }
        
    }
    
    

}

// Logic for adding the Return button on the Decimal Keyboard
extension TCEqSplitViewController{
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.billAmount.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.billAmount.resignFirstResponder()
        calculateResults()
    }
    
    
}


// Picker View Logic
extension TCEqSplitViewController{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == numGuestpickerView{
            
            return TCHelperClass.numGuestOptions.count
        }
        else {
            return TCHelperClass.tipPercentOptions.count
        }


    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == numGuestpickerView{
            
            return TCHelperClass.numGuestOptions[row]
        }
        else {
        
            return TCHelperClass.tipPercentOptions[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if pickerView == numGuestpickerView{
            
            numGuests.text = TCHelperClass.numGuestOptions[row]
            calculateResults()
            
        } else {
            
            tipPercent.text =  TCHelperClass.tipPercentOptions[row]
            calculateResults()
        }
        
        
    }

}

