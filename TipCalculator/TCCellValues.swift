//
//  TCCellValues.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/10/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

class TCCellValues {
    
    var perPersonTotal:Double
    var perPersonTip:Double
    var isCellLocked:Bool
    var isCellModified:Bool
    
    
    init(perPersonTotal:Double,perPersonTip:Double) {
        
        self.perPersonTotal = perPersonTotal
        self.perPersonTip   = perPersonTip
        
        isCellLocked = false
        isCellModified = false
    }
    
    
}
