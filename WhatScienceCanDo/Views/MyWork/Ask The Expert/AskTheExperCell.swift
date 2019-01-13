//
//  AskTheExperCell.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
import Kingfisher
class AskTheExperCell: UITableViewCell {

    @IBOutlet weak var DoctorImage: UIImageView!
    
    @IBOutlet weak var DoctorDescription: UITextView!
    @IBOutlet weak var DoctorName: UILabel!
    var id : Int!
    func ConfigureCell(Doctor : AskTheExpertModel) {
        if (Doctor.first_name != nil) && Doctor.last_name != nil {
            self.DoctorName.text =  Doctor.first_name + " " + Doctor.last_name
        }
        self.DoctorDescription.text = Doctor.description
        if Doctor.image != nil {
            self.layoutIfNeeded()

            DoctorImage.layer.cornerRadius = DoctorImage.frame.size.height/2.0
            DoctorImage.clipsToBounds = true
            let url = URL(string: ServerUrl + Doctor.image!)!
            
            self.DoctorImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "NewDoctor"), options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        if Doctor.id != nil {
            self.id = Doctor.id
        }
    }
    
}
