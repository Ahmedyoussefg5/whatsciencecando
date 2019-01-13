//
//  Event.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/6/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import Foundation
import SwiftyJSON
class Event: BaseModel {
    
    public var venue : String?
    public var lat : Double?
    public var long : Double?
    public var startDate : String?
    public var endDate : String?
    public var fileUrl : String?
    public var videoUrl : String?
    public var eventName : String?

    override init(data:AnyObject){
        super.init(data: data)
        if let data = data as? NSDictionary {
            venue = data.getValueForKey(key: "venue", callback: "")
            startDate = data.getValueForKey(key: "start_date", callback: "")
            lat = data.getValueForKey(key: "lat", callback: 0.0)
            long = data.getValueForKey(key: "long", callback: 0.0)
            endDate = data.getValueForKey(key: "end_date", callback: "")
            fileUrl = data.getValueForKey(key: "file", callback: "")
            videoUrl = data.getValueForKey(key: "url", callback: "")
            eventName = data.getValueForKey(key: "name", callback: "")
        }
    }
    init(Single : [String : JSON]) {
        super.init()
        if let EventName = Single["name"]?.string {
            self.eventName = EventName
            self.name = EventName
        }
        if let EventId = Single["id"]?.int {
            self.id = EventId
        }
        if let Venue = Single["venue"]?.string {
            self.venue = Venue
        }
        if let StartDate = Single["start_date"]?.string {
            self.startDate = StartDate
        }
        if let Lat = Single["lat"]?.double {
            self.lat = Lat
        }
        if let Long = Single["long"]?.double {
            self.long = Long
        }
        if let EndDate = Single["end_date"]?.string {
            self.endDate = EndDate
        }
        if let Image = Single["image"]?.string {
            self.image = Image
        }
    }

    
}
