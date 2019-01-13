//
//  EncyclopediaModel.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/10/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class EncyclopediaModel {
    
    var id : Int!
    var title : String!
    var content : String!
    var pdfLink : String!
    var share : Int!
    init(Single : [String : JSON]) {
        if let ID = Single["id"]?.int {
            self.id = ID
        }
        
        if let Title = Single["title"]?.string {
            self.title = Title
        }
        if let Content = Single["content"]?.string {
            self.content  = Content
        }
        if let PdfLink = Single["pdf"]?.string {
            self.pdfLink = PdfLink
        }
        if let Share = Single["shared"]?.int {
            self.share = Share
        }
        
    }
}
