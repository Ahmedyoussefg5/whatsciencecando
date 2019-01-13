//
//  EncyclopediaDepModel.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 10/8/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class EncyclopediaDepModel {
    var id : Int!
    var title : String!
    init(Single : [String : JSON]) {
        if let ID = Single["id"]?.int {
            self.id = ID
        }
       
        //description
        if let Title = Single["title"]?.string {
            self.title = Title
        }
    }
}

