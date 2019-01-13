//
//  NotificationsCell.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/24/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

import UIKit

class NotificationsCell: UITableViewCell {
    
    @IBOutlet weak var NotificationTitle: UILabel!
    
    @IBOutlet weak var NotificationContent: UILabel!
    func ConfigureCell(notification : NotificationModel) {
        //   self.NotificationTitle.text = notification.status
        //   self.TestCode.text = notification.code
        self.NotificationTitle.text = notification.title
        self.NotificationContent.text = notification.content

    }
}
