//
//  MyGroupsModel.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class MyGroupsModel {

    var id : Int!
    var user_id : Int!
    var group_id : Int!
    var accept : Int!
    var title : String!
    init(Single : [String : JSON]) {
        if let ID = Single["id"]?.int {
            self.id = ID
        }
        if let UserId = Single["user_id"]?.int {
            self.user_id = UserId
        }
        if let GroupId = Single["group_id"]?.int {
            self.group_id = GroupId
        }
        if let Accept = Single["accept"]?.int {
            self.accept = Accept
        }
        if let Title = Single["title"]?.string {
            self.title = Title
        }
        
    }
}
