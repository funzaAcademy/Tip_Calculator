//
//  TCMasterData.swift
//  TipCalculator
//
//  Created by Sanjay noronha on 7/18/16.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit


struct TCMasterData {
    
    static let pickerBkgColor = UIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 0.8)
    
    static let single_guest = "Guest"
    static let many_guests  = "Guests"
    
    static let tipSymbol  = "%"
    
    static let GuestCount = 50
    static let TipValueCount = 50
    
    static var  guests:[String]!
    static var guest_to_num_converter:[String:Int]!
    
    static var tips:[String]!
    static var tip_to_num_converter:[String:Double]!
  
    
    static func setGuestValues() {
       
        
        if let _ = guests {
            
            return
        }
        
        // Not initialized, then populate
        guests = [String]()
        guest_to_num_converter = [String:Int]()
        
        for counter in 1...GuestCount {
            
            if counter == 1 {
                guests.append( "\(counter) \(single_guest)")
                
            }
            else {
                guests?.append( "\(counter) \(many_guests)")
            }
            
            guest_to_num_converter[guests[counter - 1 ]] = counter
        }
        
        
    }
    
    
    static func setTipValues() {
        
        if let _ = tips{
            return
        }
        
        // Not initialized, then populate
        tips = [String]()
        tip_to_num_converter = [String:Double]()
        
        for counter in 1...TipValueCount {
            
            tips.append( "\(counter ) \(tipSymbol)")
            tip_to_num_converter[tips[counter - 1]] = Double(counter)
    
        }
            
        
    }
        
        
}

    
    
    

