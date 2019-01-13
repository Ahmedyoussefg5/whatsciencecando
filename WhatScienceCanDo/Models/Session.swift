//
//  Session.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/6/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import Foundation

class Session: BaseModel {
    
    public var start_time : String?
    public var end_time : String?
    public var instructor : BaseModel?
    
    override init(data:AnyObject){
        super.init(data: data)
        if let data = data as? NSDictionary {
            start_time = data.getValueForKey(key: "start_time", callback: "")
            end_time = data.getValueForKey(key: "end_time", callback: "")
            instructor = BaseModel(data: data.getValueForKey(key: "instructor", callback: [:]) as AnyObject)

        }
    }
}
