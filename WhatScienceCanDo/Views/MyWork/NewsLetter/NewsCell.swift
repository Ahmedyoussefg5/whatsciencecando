//
//  NewsCell.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/24/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var EventName: UILabel!
    var pdfLink : String!
    func ConfigureCell(News : NewsModel) {
        self.EventName.text = News.name
        if News.pdfLink != nil {
            self.pdfLink = News.pdfLink
        }
    }

}
