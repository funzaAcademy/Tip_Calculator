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
    
    @IBAction func doCalculate(sender: AnyObject) {
        
        calculateResults()
    }
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //Set Master Data
        TCMasterData.setGuestValues()
        TCMasterData.setTipValues()
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self

        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self

        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        // Return button on keyboard
        self.addDoneButtonOnKeyboard()
        
    }
    
    func calculateResults() {
        
        if let numGuests = TCMasterData.guest_to_num_converter[numGuests.text!],
            tipPercent = TCMasterData.tip_to_num_converter[tipPercent.text!],
            billAmount = Double(billAmount.text!){
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            totalTipToPay.text = String(format: "%.2f", TCHelperClass.getTotalTip())
            
            totalToPay.text =  String(format: "%.2f", billAmount + TCHelperClass.getTotalTip())
            
            totalPerPerson.text = String(format: "%.2f", TCHelperClass.getPerPersonAmount() + TCHelperClass.getPerPersonTip())
            
            tipPerPerson.text = String(format: "%.2f", TCHelperClass.getPerPersonTip() )
            
        } else {
            
            numGuests.text = ""
            tipPercent.text = ""
            billAmount.text = ""
        }
        
    }


}

// MARK: Logic for adding the Return button on the Decimal Keyboard
extension TCEqSplitViewController{
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
       
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(doneButtonAction))
        
       
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
        
        if pickerView == numGuestpickerView{
            
            numGuests.text = TCMasterData.guests[row]
            
        } else {
            
            tipPercent.text =  TCMasterData.tips[row]
        }
        
        
    }
    
}
