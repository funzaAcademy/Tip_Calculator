//
//  TCInEqSplitViewController.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/10/16.
//  Copyright © 2016 funza Academy. All rights reserved.


import UIKit

class TCInEqSplitViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource,TCTableViewCellProtocol,UITextFieldDelegate  {
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
   
    @IBOutlet weak var tableView: UITableView!
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
    private var keyboardOn = false //comments in func: dismissKeyboard()
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //Identify the active VC
        TCHelperClass.isFirstVC = false
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //initially hide Results
        bottomView.alpha = 0
        
        //Text Field Delegates
        numGuests.delegate = self
        tipPercent.delegate = self
        
        //Set Master Data
        TCMasterData.setGuestValues()
        TCMasterData.setTipValues()
        
        //Picker View
        numGuestpickerView = UIPickerView()
        numGuestpickerView.delegate = self
        numGuestpickerView.backgroundColor = TCMasterData.pickerBkgColor
        
        tipPercentpickerView = UIPickerView()
        tipPercentpickerView.delegate = self
        tipPercentpickerView.backgroundColor = TCMasterData.pickerBkgColor
        
        numGuests.inputView = numGuestpickerView
        tipPercent.inputView = tipPercentpickerView
        
        tableView.dataSource = self
        
        TCHelperClass.addDoneButtonOnKeyboard(self, sendingTextFld: billAmount)
        
        //Tap gesture recognizer
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func doCalculate(sender: AnyObject) {
        
        calculateResults()
    
    }
    
    func calculateResults() {
        
        //resign first responder
        dismissKeyboard()
        
        if let numGuests = TCMasterData.guest_to_num_converter[numGuests.text!],
            tipPercent = TCMasterData.tip_to_num_converter[tipPercent.text!],  
            billAmount = Double(billAmount.text!){
        
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            totalTipToPay.text = String(format: "%.2f", TCHelperClass.getTotalTip())
            totalToPay.text =  String(format: "%.2f", billAmount + TCHelperClass.getTotalTip())
            
            tableView.reloadData()
            
            //show the results
            if self.bottomView.alpha == 0.0 {
                
                UIView.animateWithDuration(TCMasterData.animationDuration) {
                    self.bottomView.alpha = 1.0
                }
            }
            
        }else {
            
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

// MARK: TCTableViewCellProtocol protocol
extension TCInEqSplitViewController{
    
    func calcAndReload() -> Void {

        TCHelperClass.resetCellValues()
        tableView.reloadData()
    }
    
   
    func keyboardWillShow(notification: NSNotification) {
        
        if !keyboardOn  {
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardOn = true
            
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardOn {
            
            view.frame.origin.y += getKeyboardHeight(notification)
            keyboardOn = false
            
        }

    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
       
        return keyboardSize.CGRectValue().height
    }
    
}

// MARK: Logic for adding the Return button on the Decimal Keyboard
extension TCInEqSplitViewController{
    
    
    func doneButtonAction()
    {
        self.billAmount.resignFirstResponder()
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        /*
         * If the Y coordinate is decreased and if this function is triggered
         * then the 'notification' object has a 0 height value
         * So the y coordinate is not increased
         * Thus this  tap gesture function is only called when the keyboard y coordinate
         * is not in the decreased state
        */
        if !keyboardOn {
            view.endEditing(true)
        }
    }
    
    
}

// MARK: Table View Data Source functions
extension TCInEqSplitViewController{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let helperArray = TCHelperClass.tcCellValues {
            
            return helperArray.count
        }
        
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TCMasterData.cellIdentifier) as! TCTableViewCell
        
       if let helperArray = TCHelperClass.tcCellValues {
            cell.myCellDetails =    helperArray[indexPath.row]
            cell.personLabel.text = "Guest \(indexPath.row + 1)"
            
            cell.delegate = self
        }
        
        return cell
        
    }
    
}

// MARK: Picker View functions
extension TCInEqSplitViewController{
    
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
extension TCInEqSplitViewController {
    
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


