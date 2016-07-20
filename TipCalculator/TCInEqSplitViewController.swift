//
//  TCInEqSplitViewController.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/10/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

class TCInEqSplitViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource,TCTableViewCellProtocol {
    
    
    @IBOutlet weak var numGuests: UITextField!
    @IBOutlet weak var tipPercent: UITextField!
    @IBOutlet weak var billAmount: UITextField!
    
    @IBOutlet weak var totalToPay: UITextField!
    @IBOutlet weak var totalTipToPay: UITextField!
   
    @IBOutlet weak var tableView: UITableView!
    
   /* var tcCellValues:[TCCellValues]? {
        didSet{
            
            print ("roger wilco")
            if let _ = tcCellValues {
                
            tableView.reloadData()
            
            }
            
        }

    }
  */
    
    var numGuestpickerView:UIPickerView!
    var tipPercentpickerView:UIPickerView!
    
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
        
        tableView.dataSource = self
        
        self.addDoneButtonOnKeyboard()
        
    }
    //         Int(numGuests.text!),
    
    func calculateResults() {
        
        if let numGuests = TCMasterData.guest_to_num_converter[numGuests.text!],
            tipPercent = TCMasterData.tip_to_num_converter[tipPercent.text!],  
            billAmount = Double(billAmount.text!){
            
            print("Number of guests is : \(numGuests)")
            
            totalTipToPay.text = String(round( billAmount * tipPercent / 100 * 100 ) / 100)
            totalToPay.text =  String (round ((billAmount + Double(totalTipToPay.text!)!) * 100 ) / 100 )
            
            TCHelperClass.billAmount = billAmount
            TCHelperClass.numGuests = numGuests
            TCHelperClass.tipPercent = tipPercent
            
            //tcCellValues = TCHelperClass.tcCellValues
            
            tableView.reloadData()
            
        }
        
    }
    
    
    
}

// MARK: TCTableViewCellProtocol protocol
extension TCInEqSplitViewController{
    
    func calcAndReload() -> Void {

        TCHelperClass.seCellValues()
        tableView.reloadData()
    }
    
}

// MARK: Logic for adding the Return button on the Decimal Keyboard
extension TCInEqSplitViewController{
    
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
        calculateResults()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myTCCell") as! TCTableViewCell
        
        cell.myCellDetails = TCHelperClass.tcCellValues![indexPath.row]
        
        cell.delegate = self
        
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
        
        if pickerView == numGuestpickerView{
            
            numGuests.text = TCMasterData.guests[row]
            calculateResults()
            
        } else {
            
            tipPercent.text =  TCMasterData.tips[row]
            calculateResults()
        }
        
        
    }
    
}


