//
//  ExpandableHeaderView.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header : ExpandableHeaderView , section : Int)
}
class ExpandableHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var MainCheckButton: UIButton!
    
    @IBOutlet weak var MainTitleLabel: UILabel!
    
    
    var delegate : ExpandableHeaderViewDelegate?
    var section : Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
        
    }
    
    
    @objc func selectHeaderAction(gestureRecognizer : UITapGestureRecognizer ) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    func customInit(title : String , id : Int, section : Int ,  delegate : ExpandableHeaderViewDelegate) {
        print("Title" , title)
        self.MainTitleLabel?.text = title
        self.MainCheckButton?.tag = section + 50000
        
        self.section = section
        self.delegate = delegate
    }
    
    
}

