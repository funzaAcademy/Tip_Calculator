//
//  TCCellValues.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/10/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import Foundation

class TCCellValues {
    
    var perPersonTotal:Double //excludes the tip amount
    var perPersonTip:Double
    var isCellLocked:Bool     // this happens when a cell amount is changed 
                              
    
    
    init(perPersonTotal:Double,perPersonTip:Double) {
        
        self.perPersonTotal = perPersonTotal
        self.perPersonTip   = perPersonTip
        
        isCellLocked = false
        
    }
    
    
}
