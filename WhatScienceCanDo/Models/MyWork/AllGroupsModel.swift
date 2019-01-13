//
//  AllGroupsModel.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class AllGroupsModel {
    
    var id : Int!
    var title : String!
    init(Single : [String : JSON]) {
        if let ID = Single["id"]?.int {
            self.id = ID
        }
     
        if let Title = Single["title"]?.string {
            self.title = Title
        }
        
    }
}
