//
//  ChatGroupCell.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class ChatGroupCell: UITableViewCell {

    @IBOutlet weak var GroupName: UILabel!
    
    @IBOutlet weak var GroupButton: UIButton!
    var groupId : Int!
    func ConfigureCell(Groups :MyGroupsModel) {
        self.GroupName.text = Groups.title
        self.GroupButton.tag = Groups.id
    }

    func ConfigureJoin(Groups : AllGroupsModel) {
        self.GroupName.text = Groups.title
        self.GroupButton.tag = Groups.id
    }
}
