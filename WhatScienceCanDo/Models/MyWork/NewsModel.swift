//
//  NewsModel.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/24/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class NewsModel {
    var id : Int!
    var name : String!
    var video : String!
    var link : String!
    var date : String!
    var image : String!
    var lowImage : String!
    var pdfLink : String!
    init(Single : [String : JSON]) {
        if let ID = Single["id"]?.int {
            self.id = ID
        }
        if let Name = Single["name"]?.string {
            self.name = Name
        }
        if let Video = Single["video"]?.string {
            self.video = Video
        }
        if let Linke = Single["link"]?.string {
            self.link = Linke
        }
        if let Date = Single["date"]?.string {
            self.date = Date
        }
        if let Image = Single["image"]?.string {
            self.image = Image
        }
        if let LowImage = Single["low_image"]?.string {
            self.lowImage = LowImage
        }
        if let PdfLink = Single["file"]?.string {
            self.pdfLink = PdfLink
        }
        
    }
}

