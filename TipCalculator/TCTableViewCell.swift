//
//  TCTableViewCell.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/12/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//



import UIKit

protocol TCTableViewCellProtocol:class  {
    
    func calcAndReload() -> Void
    func keyboardWillShow(notification: NSNotification) -> Void
    func keyboardWillHide(notification: NSNotification) -> Void
}


class TCTableViewCell:UITableViewCell,UITextFieldDelegate {

    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var rowIsLocked: UISwitch!
    weak var delegate:TCTableViewCellProtocol?
    
    var oldAmountValue:Double!
    
    var myCellDetails:TCCellValues? {
        
        didSet{
            
            
            if let myCellDetails = myCellDetails{
               
                self.amount.text = String(format: "%.2f", myCellDetails.perPersonTotal)
                self.tipAmount.text = String(format: "%.2f", myCellDetails.perPersonTip)
                self.totalAmount.text = String(format: "%.2f", myCellDetails.perPersonTip + myCellDetails.perPersonTotal)
                
                oldAmountValue = Double(self.totalAmount.text!)
               
                if myCellDetails.isCellLocked {
                    
                    rowIsLocked.setOn(true, animated: false)
                    
                } else {
                   
                    if rowIsLocked.on{
                        
                        rowIsLocked.setOn(false, animated: false)
                    
                    }
                    
                }
                
                if oldValue == nil {
                    
                    //assumption that this will be triggered the first time only
                    totalAmount.addTarget(self, action: #selector(totalAmountDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
                   
                    TCHelperClass.addDoneButtonOnKeyboard(self, sendingTextFld: totalAmount)
                    
                    totalAmount.delegate = self
                    
      
            }
        }
        
    }
   
}

    
    @IBAction func sliderDidChange(sender: AnyObject) {
        
        
        if rowIsLocked.on {
            
            myCellDetails?.isCellLocked = true
        }
        else {
            myCellDetails?.isCellLocked = false
        }
    }
    
    
    
    
    func totalAmountDidChange(textField: UITextField) {
        
        if let changedAmountValue = Double(textField.text!) {
            
            // only if the new value is different from the old one
            if ( oldAmountValue != changedAmountValue) {
                
                (myCellDetails!.perPersonTip,myCellDetails!.perPersonTotal) = TCHelperClass.recalcTipAndAmountValues(changedAmountValue)
               
                // trigger both the UI component and the cell value
                // surely there is a better way to do this...
                rowIsLocked.setOn(true, animated: true)
                myCellDetails?.isCellLocked = true

                if let delegate = delegate {
                    
                    delegate.calcAndReload()
                }
                
                oldAmountValue = changedAmountValue
            }
        }
        
    }
    

}

extension TCTableViewCell{
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        delegate?.keyboardWillShow(notification)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        delegate?.keyboardWillHide(notification)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
}

extension TCTableViewCell {
    
    
    func doneButtonAction()
    {
        
        subscribeToKeyboardNotifications()
        self.totalAmount.resignFirstResponder()

    }

    
}

 //MARK: UITextFieldDelegate functions
extension TCTableViewCell {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        subscribeToKeyboardNotifications()
        
    }

}

