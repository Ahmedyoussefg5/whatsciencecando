//
//  CheckCircle.swift
//  Modazee
//
//  Created by Ahmed_OS on 5/10/17.
//  Copyright © 2017 Ahmed_OS. All rights reserved.
//
import UIKit

class ToggleButton: DesignableUIButton {
    
    //bool propety
    var isChecked:Bool = false{
        didSet{            
            if self.isChecked == true{
                self.backgroundColor = appBrown
                self.tintColor = appGold
                self.layer.borderColor = appGold.cgColor
            }else{
                self.tintColor = .white
                self.backgroundColor = .clear
                self.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
        
    override func awakeFromNib() {
        isChecked = false
    }

}
