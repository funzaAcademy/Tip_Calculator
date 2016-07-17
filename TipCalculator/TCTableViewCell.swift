//
//  TCTableViewCell.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/12/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//

////////////Resources////////////////
/*
 //
 // http://stackoverflow.com/questions/33471858/swift-protocol-weak-cannot-be-applied-to-non-class-type
 //
*/


import UIKit

protocol TCTableViewCellProtocol:class  {
    
    func calcAndReload() -> Void
}


class TCTableViewCell:UITableViewCell {
    
    //Pseudo code
    // user changes a tip value
    // the changed column  is noted
    // all the column values are recalculated
    // the column changed values are reset
    // the cells are reloaded
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var tipAmount: UITextField!
    @IBOutlet weak var canChangeValue: UISwitch!
    
    weak var delegate:TCTableViewCellProtocol?

    var oldTipAmount:Double?
    
    var myCellDetails:TCCellValues? {
        
        didSet{
            
            if let myCellDetails = myCellDetails{
               
                self.totalAmount.text = String(myCellDetails.perPersonTotal)
                self.tipAmount.text = String(myCellDetails.perPersonTip)
                
                if oldValue == nil {
                    
                    oldTipAmount = Double(tipAmount.text!)
                    
                    tipAmount.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
      
            }
        }
        
    }
   
}
    
    func textFieldDidChange(textField: UITextField) {
        
        if let value = Double(textField.text!) {
            
            myCellDetails!.perPersonTip = value
            
        }
        else {
            myCellDetails?.perPersonTip = 0.0
        }
        
        myCellDetails!.isCellModified = true
        
        if canChangeValue.on == true {
            
            myCellDetails!.isCellLocked = false
            
        }
        else {
            
            myCellDetails!.isCellLocked = true
            
        }
        
        myCellDetails!.perPersonTotal = myCellDetails!.perPersonTotal - oldTipAmount! + myCellDetails!.perPersonTip
        
        oldTipAmount = myCellDetails!.perPersonTip
        
        if let delegate = delegate {
            
            delegate.calcAndReload()
        }
        
    }

}

