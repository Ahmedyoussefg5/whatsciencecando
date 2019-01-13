//
//  EncyclopediaDepCell.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 10/8/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class EncyclopediaDepCell: UITableViewCell {
    @IBOutlet weak var DepTitle: UILabel!
    var DepId : Int!
    
    func ConfigureCell(Article : EncyclopediaDepModel) {
        if Article.id != nil {
            self.DepTitle.text = Article.title
            self.DepId = Article.id
        }
    }
    
}
