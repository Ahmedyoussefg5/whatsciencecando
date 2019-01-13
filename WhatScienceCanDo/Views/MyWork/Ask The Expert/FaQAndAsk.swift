//
//  FaQAndAsk.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class FaQAndAsk: BaseViewController {
    lazy var Notifications : UIBarButtonItem = {
        
        let viewFN = NotificationView()
        viewFN.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let image = UIImage.init(named: "AstraLogo")!.withRenderingMode(.alwaysOriginal)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(#imageLiteral(resourceName: "AstraLogo"), for: .normal)
        let button1 = UIButton(frame: CGRect(x: 0, y: 20, width: 10, height: 10))
        //NotificationView
        button.addTarget(self, action: #selector(NotifictionFunction), for: .touchUpInside)
        button1.setTitle(String(CountingNotification), for: .normal)
        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button1.titleLabel!.adjustsFontSizeToFitWidth = true
        button1.titleLabel!.baselineAdjustment = .alignCenters
        viewFN.addSubview(button)
        viewFN.addSubview(button1)
        
        // viewFN.backgroundColor = .default
        
        
        // viewFN.backgroundColor = UIColor.yellow
        //     view.NotificationCounter.text = "1"
        
        let Notifications = UIBarButtonItem(customView: viewFN)
        return Notifications
    }();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ask the expert"
        self.activityIndicator.stopAnimating()
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
