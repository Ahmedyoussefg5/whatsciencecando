//
//  EncyclopediaCell.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/10/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class EncyclopediaCell: UITableViewCell {

    @IBOutlet weak var ArticleTitle: UILabel!
    
    
    func ConfigureCell (article : EncyclopediaModel) {
        self.ArticleTitle.text = article.title
    }
}
