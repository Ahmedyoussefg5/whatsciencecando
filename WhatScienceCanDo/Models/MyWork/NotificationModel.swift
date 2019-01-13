//
//  NotificationModel.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/24/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class NotificationModel {
    var id : Int!
    var title : String!
    var content : String!
    var type : String!
    var code : String!
    var type_id : Int!
    init(Single : [String : JSON]) {
        if let ID = Single["id"]?.int {
            self.id = ID
        }
        if let Title = Single["title"]?.string {
            self.title = Title
        }
        if let Content = Single["content"]?.string {
            self.content = Content
        }
        if let test_id = Single["test_id"]?.int {
            self.code = String(test_id)
        }
        if let NotifyType = Single["type"]?.string {
            self.type = NotifyType
        }
        if let TypID = Single["type_id"]?.int {
            self.type_id = TypID
        }
        
    }
}

