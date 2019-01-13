//
//  AskTheExpertModel.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class AskTheExpertModel {
    var id : Int!
    var first_name : String!
    var last_name : String!
    var email : String!
    var image : String!
    var description : String!
    init(Single : [String : JSON]) {
        if let ID = Single["id"]?.int {
            self.id = ID
        }
        if let FirstName = Single["first_name"]?.string {
            self.first_name = FirstName
        }
        if let LastName = Single["last_name"]?.string {
            self.last_name = LastName
        }
        if let Email = Single["email"]?.string {
            self.email = Email
        }
        
        if let Image = Single["image"]?.string {
            self.image = Image
        }
        //description
        if let Description = Single["description"]?.string {
            self.description = Description
        }
    }
}
