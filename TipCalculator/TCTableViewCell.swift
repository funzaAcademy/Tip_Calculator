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

    //var oldTipAmount:Double?
    
    var myCellDetails:TCCellValues? {
        
        didSet{
            
            
            if let myCellDetails = myCellDetails{
               
                self.amount.text = String(format: "%.2f", myCellDetails.perPersonTotal)
                self.tipAmount.text = String(format: "%.2f", myCellDetails.perPersonTip)
                self.totalAmount.text = String(format: "%.2f", myCellDetails.perPersonTip + myCellDetails.perPersonTotal)
               
                if myCellDetails.isCellLocked {
                    
                    rowIsLocked.setOn(true, animated: false)
                    
                } else {
                   
                    rowIsLocked.setOn(false, animated: false)
                    
                }
                
                if oldValue == nil {
                    
                    //oldTipAmount = Double(tipAmount.text!)
                    totalAmount.addTarget(self, action: #selector(totalAmountDidChange(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
                   
                    self.addDoneButtonOnKeyboard()
                    totalAmount.delegate = self
                    
      
            }
        }
        
    }
   
}
    func textFieldDidBeginEditing(textField: UITextField) {
        
        print("did begin editing")
        subscribeToKeyboardNotifications()
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
        
        
        (myCellDetails!.perPersonTip,myCellDetails!.perPersonTotal) = TCHelperClass.recalcTipAndAmountValues(Double(textField.text!)!)
        
        print(myCellDetails!.perPersonTip )
        print(myCellDetails!.perPersonTotal)
        
        rowIsLocked.setOn(true, animated: true)
        myCellDetails?.isCellLocked = true

       if let delegate = delegate {
            
            delegate.calcAndReload()
        }
    
        
    }
    

}

extension TCTableViewCell{
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("\(personLabel.text) : keyboardWillShow ")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        delegate?.keyboardWillShow(notification)
        
       
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("\(personLabel.text) : keyboardWillHide ")
        delegate?.keyboardWillHide(notification)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
}

extension TCTableViewCell {
    
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
        
        self.totalAmount.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.totalAmount.resignFirstResponder()
        unsubscribeFromKeyboardNotifications()
    }

    
}


