//
//  DesignableButton.swift
//  CafeSupreme
//
//  Created by Ahmed on 10/18/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableUIButton: UIButton {
    
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//            updateView()
//        }
//    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
//        if let color = borderColor {
            self.clipsToBounds = true
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.layer.cornerRadius = cornerRadius
//        }else {
//            self.clipsToBounds = false
//            self.layer.cornerRadius = 0
//        }
    }
}
