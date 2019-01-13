//
//  NotificationVC.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/24/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
import SwiftyJSON
/// Declare User Notifications
class Notifications: BaseViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    lazy var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
        return refresher
    }()
 
    var current_page :Int = 1
    var last_page : Int = 1
    var isLoading : Bool = false
    var Tests = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notifications"
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refresher)
        
        handelRefresh()
        // Do any additional setup after loading the view.
    }
    /**
     navigate to pervious screen
     
     */
    @objc func BackFunction () {
        self.dismiss(animated: true, completion: nil)
    }
    /**
     number of sections
     
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /**
     number of items in table view
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tests.count
    }
    /**
     declare cell
     
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as! NotificationsCell
        let test = Tests[indexPath.row]
        cell.selectionStyle = .none

        cell.ConfigureCell(notification: test)
        
        return cell
    }
    /**
     fetch all items
     
     */
    @objc private func handelRefresh() {
        self.refresher.endRefreshing()
        guard !isLoading else {return}
        isLoading = true
        if let api_token = ApiToken.getApiToken() {
            ApiMethods.GetNotifications(api_token: api_token) { (status,error ,tests , last_page) in
                self.activityIndicator.stopAnimating()
                self.isLoading = false
                if let tests = tests {
                    self.Tests = tests
                    self.tableView.reloadData()
                    self.current_page = 1
                    self.last_page = last_page!
                }
                
            }
        }
    }
    /**
     load more data
     
     */
    func loadMore ()  {
        
        guard !isLoading else {return}
        guard current_page < last_page else {return}
        isLoading = true
        if let api_token = ApiToken.getApiToken() {
            ApiMethods.GetNotifications(api_token: api_token, page: self.current_page+1) { (status,error ,tests , last_page) in
                
                self.isLoading = false
                if let tests = tests {
                    self.Tests.append(contentsOf: tests)
                    self.tableView.reloadData()
                    self.current_page += 1
                    self.last_page = last_page!
                }
            }
            
        }
    }
    /**
     check if there is more data
     
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.Tests.count
        if indexPath.row == count-1 {
            self.loadMore()
        }
    }
    
    
    
    /**
     declare cell height
     
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.00;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        //type => events, newsletters, chat, encyclopedia
        // EventInfoSegue. ////.   NewsletterInfoSegue /// ChatInfoSegue ///. EncyclopediaInfoSegue
        let notify = self.Tests[indexPath.row]
        print("Notify type :" , notify.type)
        if notify.type == "events" {
self.EventSegue(sender: notify)
            // performSegue(withIdentifier: "EventInfoSegue", sender: self.Tests[indexPath.row])

        }else if notify.type == "newsletters" {
            self.NewsLetterSegue(sender: notify)
            //performSegue(withIdentifier: "NewsletterInfoSegue", sender: self.Tests[indexPath.row])

        }else if notify.type == "chat" {
            self.ChatSegue(sender: notify)
           // performSegue(withIdentifier: "ChatInfoSegue", sender: self.Tests[indexPath.row])

        }else if notify.type == "encyclopedia" {
            self.Encyc(sender: notify)

            //performSegue(withIdentifier: "EncyclopediaInfoSegue", sender: self.Tests[indexPath.row])

        }else if notify.type == "push" {
            self.PushSegue(sender: notify)
        }
        
    }
    /**
     navigate to test details screens
     
     
     */
    func PushSegue (sender : NotificationModel) {
        let dist =  self.storyboard?.instantiateViewController(withIdentifier: "NewsLetterVC") as! NewsLetterVC
        if let Item = sender as? NotificationModel {
            if let api_token = ApiToken.getApiToken() {
                ApiMethods.GetDataForSingleNotification(api_token: api_token, type_id: Item.type_id, notifyType: Item.type, compltion: { (status, error , data) in
                    
                    let url = data!["content"]?.string
                    if let url = URL(string: url!) {
                        UIApplication.shared.open(url, options: [:])
                    }
                   // self.present(vc, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(dist, animated: true)
                    
                    
                })
                
            }
        }
    }
    func NewsLetterSegue(sender : NotificationModel) {
        
         let dist =  self.storyboard?.instantiateViewController(withIdentifier: "NewsLetterVC") as! NewsLetterVC
            if let Item = sender as? NotificationModel {
                if let api_token = ApiToken.getApiToken() {
                    guard Item.type != nil else {return}
                    guard Item.type_id != nil else {return}
                    ApiMethods.GetDataForSingleNotification(api_token: api_token, type_id: Item.type_id, notifyType: Item.type, compltion: { (status, error , data) in
                        
                        let objData = NewsModel(Single: data!)
                        //  print("ObjData" ,objData.name)
                        dist.Months = objData.name
                        dist.Photos = objData.image
                        dist.Videos  = objData.video
                        dist.Links = objData.link
                        dist.Low = objData.lowImage
                        dist.pdfFile = objData.pdfLink
                        
                        self.navigationController?.pushViewController(dist, animated: true)

                        
                    })
                    
                }
            }
        
    }
    func ChatSegue (sender : NotificationModel) {
        let dist =  self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        if let Item = sender as? NotificationModel {
            guard Item.type != nil else {return}
            guard Item.type_id != nil else {return}
            if let api_token = ApiToken.getApiToken() {
                print("Type" , Item.type)
                print("type id" , Item.type_id)
                ApiMethods.GetDataForSingleNotification(api_token: api_token, type_id: Item.type_id, notifyType: Item.type, compltion: { (status, error , data) in
                    
                    let objData = MyGroupsModel(Single: data!)
                    //  print("ObjData" ,objData.name)
                    dist.nickname = ApiToken.GetItem(Key: "first_name") + " " + ApiToken.GetItem(Key: "last_name")
                        dist.groupId = objData.id
                        dist.ChatName = objData.title
                    
                    self.navigationController?.pushViewController(dist, animated: true)
                    
                    
                })
                
            }
        }
    }
    func Encyc (sender : NotificationModel) {
        let dist =  self.storyboard?.instantiateViewController(withIdentifier: "EncyclopediaDetailsVC") as! EncyclopediaDetailsVC
        if let Item = sender as? NotificationModel {
            guard Item.type != nil else {return}
            guard Item.type_id != nil else {return}
            if let api_token = ApiToken.getApiToken() {
                print("Type" , Item.type)
                print("type id" , Item.type_id)
                ApiMethods.GetDataForSingleNotification(api_token: api_token, type_id: Item.type_id, notifyType: Item.type, compltion: { (status, error , data) in
                    
                    let objData = EncyclopediaModel(Single: data!)
                    //  print("ObjData" ,objData.name)
                 dist.Article = objData
                    
                    self.navigationController?.pushViewController(dist, animated: true)
                    
                    
                })
                
            }
        }
    }
    func EventSegue(sender : NotificationModel) {
        let dist =  self.storyboard?.instantiateViewController(withIdentifier: "EventsInfoVC") as! EventsInfoVC
        if let Item = sender as? NotificationModel {
            guard Item.type != nil else {return}
            guard Item.type_id != nil else {return}
            if let api_token = ApiToken.getApiToken() {
                print("Type" , Item.type)
                print("type id" , Item.type_id)
                ApiMethods.GetDataForSingleNotification(api_token: api_token, type_id: Item.type_id, notifyType: Item.type, compltion: { (status, error , data) in
                    
                    if data != nil {
                        let testEvent = Event(Single: data!)
                    dist.event = testEvent
                    self.navigationController?.pushViewController(dist, animated: true)
                    }
                    
                })
                
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue" , segue.identifier)
        if segue.identifier == "EventInfoSegue" {
            //http://localhost/wscd/public/api/getdataforid?api_token=855b8cb97aa450776c1ae196451e244e637d72f3e0c1032f7728321fbd1e0b79f4bc0cea&type=events&type_id=52
            if let dist = segue.destination as? EventsInfoVC {
                //if let item = sender as? Eve
            }
        }else if segue.identifier == "NewsletterInfoSegue" {
            if let dist = segue.destination as? NewsLetterVC {
                if let Item = sender as? NotificationModel {
                    if let api_token = ApiToken.getApiToken() {
                        ApiMethods.GetDataForSingleNotification(api_token: api_token, type_id: Item.type_id, notifyType: Item.type, compltion: { (status, error , data) in
                            
                            let objData = NewsModel(Single: data!)
                          //  print("ObjData" ,objData.name)
                            dist.Months = data!["name"]?.string
                            dist.Photos = " objData.image"
                            dist.Videos  = objData.video
                            dist.Links = objData.link
                            dist.Low = objData.lowImage
                            dist.pdfFile = objData.pdfLink
                           

                            
                        })
                   
                    }
                }
            }
            
        }else if segue.identifier == "ChatInfoSegue" {
            if let dist = segue.destination as? ChatViewController {
                if let item = sender as? MyGroupsModel {
                    dist.groupId = item.group_id
                    dist.ChatName = item.title
                }
            }
        }else if segue.identifier == "EncyclopediaInfoSegue" {
            if let dist = segue.destination as? EncyclopediaDetailsVC {
                if let Item = sender as? EncyclopediaModel {
                    dist.Article = Item
                    
                    
                }
                
            }
        }
        
    
        
    }
    
}

