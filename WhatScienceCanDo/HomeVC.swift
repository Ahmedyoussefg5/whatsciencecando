//
//  HomeVC.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/5/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit

var CountingNotification = 0
class HomeVC: UITableViewController {
    /*
    lazy var Notification : UIBarButtonItem = {
        let image = UIImage.init(named: "AstraLogo")!.withRenderingMode(.alwaysOriginal)
            
        
        let Notification = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(NotifictionFunction))
        return Notification
    }();
 */
    lazy var Notifications : UIBarButtonItem = {

        let viewFN = NotificationView()
        viewFN.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            let image = UIImage.init(named: "AstraLogo")!.withRenderingMode(.alwaysOriginal)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(#imageLiteral(resourceName: "AstraLogo"), for: .normal)
        let button1 = UIButton(frame: CGRect(x: 0, y: 20, width: 10, height: 10))
        //NotificationView
        button.addTarget(self, action: #selector(NotifictionFunction), for: .touchUpInside)
        if CountingNotification == 0 {
            button1.setTitle("", for: .normal)

        }else {
        button1.setTitle(String(CountingNotification), for: .normal)
        }
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
    //    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:UIImageView(image: UIImage(named: "btn_back")))

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var NewsLetterCount: UILabel!
    @IBOutlet weak var EventNotificationCount: UILabel!
    
    @IBOutlet weak var GroupNotificationCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
       // Messaging.messaging().subscribe(toTopic: "")
        print("Api Token" , ApiToken.getApiToken())
        print("Conting", CountingNotification)

        if self.revealViewController() != nil
        {
            revealViewController().rightViewController = nil
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        RequestManager.defaultManager.sendDeviceToken(compilition: { (error, recError) in
            print("Notification Error" , error)
        })

       
        let imageview = UIImageView(frame: self.view.frame)
        imageview.image = #imageLiteral(resourceName: "a")
//        imageview.contentMode = .scaleAspectFill
        
        self.tableView.backgroundView = imageview

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.GetNotificationCounter() { (counter) in
            CountingNotification = counter
            self.navigationItem.setRightBarButtonItems([self.Notifications], animated: true)

        }

    }
    @objc func NotifictionFunction() {
        print("Notifications")
//NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        self.navigationController?.pushViewController(myVC, animated: true)
        //self.present(myVC, animated: true, completion: nil)
    }

    func GetNotificationCounter ( compltion : @escaping (_ counter: Int)->Void){
        if let api_token = ApiToken.getApiToken() {
            ///  compltion(status, api_token_status, EventCounter ,NewsLetterCounter ,  chatCounter, nil)
            ApiMethods.GetNotificationCounter(api_token: api_token, compltion: { (status, api_token_status, eventCounter, NewsLetterCounter, chatCounter, error ) in
                if error == nil {
                    if status == true {
                        if api_token_status == true {
                            if eventCounter != 0 {
                            self.EventNotificationCount.text = String(describing: eventCounter!)
                            }
                            if NewsLetterCounter != 0 {
                            self.NewsLetterCount.text = String(describing: NewsLetterCounter!)
                            }
                            if chatCounter != 0 {
                            self.GroupNotificationCount.text = String(describing: chatCounter!)
                            }
                          let  NotificationCounter = eventCounter! + NewsLetterCounter! + chatCounter!
                            compltion(NotificationCounter)
                        }
                    }
                }
            })
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "NewsLetter"?:
            showEventsCalendar = false
        default:
            showEventsCalendar = true
        }
    }
        
}
