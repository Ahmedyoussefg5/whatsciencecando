//
//  EncyclopediaVC.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/10/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class EncyclopediaVC: BaseViewController , UITableViewDelegate , UITableViewDataSource  {
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
    var DepId : Int!
    var Articles = [EncyclopediaModel]()
    lazy var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
        return refresher
    }()
    
    
    var current_page :Int = 1
    var last_page : Int = 1
    var isLoading : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

        // self.navigationItem.setRightBarButtonItems([Notification], animated: true)
        
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refresher)
        self.title = "AZ encyclopedia"
        handelRefresh()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.UpdateNotification { (status) in
            if status == true {
                self.GetNotificationCounter { (counter) in
                    CountingNotification = counter
                    self.navigationItem.setRightBarButtonItems([self.Notifications], animated: true)
                    
                }
            }
        }
        
    }
    public func UpdateNotification (compltion : @escaping (_ status: Bool)->Void) {
        if let api_token = ApiToken.getApiToken() {
            ApiMethods.UpdateNotification(api_token: api_token, notification_Type: "encyclopedia", compltion: { (status, api_token_status, error ) in
                if error == nil {
                    if status == true {
                        if api_token_status == true {
                            compltion(true)
                        }
                    }
                }
            })
        }
    }
    func GetNotificationCounter ( compltion : @escaping (_ counter: Int)->Void){
        if let api_token = ApiToken.getApiToken() {
            ///  compltion(status, api_token_status, EventCounter ,NewsLetterCounter ,  chatCounter, nil)
            ApiMethods.GetNotificationCounter(api_token: api_token, compltion: { (status, api_token_status, eventCounter, NewsLetterCounter, chatCounter, error ) in
                if error == nil {
                    if status == true {
                        if api_token_status == true {
                            
                            let  NotificationCounter = eventCounter! + NewsLetterCounter! + chatCounter!
                            compltion(NotificationCounter)
                        }
                    }
                }
            })
        }
    }
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    /**
     number of sections
     
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /**
     count items to load
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Articles.count
    }
    /**
     Declare cell type
     
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncyclopediaCell") as! EncyclopediaCell
        cell.selectionStyle = .none

        let article = Articles[indexPath.row]
        cell.ConfigureCell(article: article)
        
        return cell
    }
    /**
     Load Items
     
     */
    @objc private func handelRefresh() {
        self.refresher.endRefreshing()
        guard !isLoading else {return}
        isLoading = true
        if let api_token = ApiToken.getApiToken() {
            
            ApiMethods.GetEncyclopediaArticles(api_token: api_token, sectionId: self.DepId, compltion: { (status, error, api_token_status, articles, last_page) in
                self.activityIndicator.stopAnimating()
                
                self.isLoading = false
                if let articles = articles {
                    self.Articles = articles
                    self.tableView.reloadData()
                    self.current_page = 1
                    self.last_page = last_page!
                }
            })
            
                }
                
            }

    /**
     Load More Items
     
     */
    func loadMore ()  {
        
        guard !isLoading else {return}
        guard current_page < last_page else {return}
        isLoading = true
        if let api_token = ApiToken.getApiToken() {
            
            ApiMethods.GetEncyclopediaArticles(api_token: api_token, sectionId: self.DepId, page: self.current_page+1) { (status,api_token_status,error ,articles , last_page) in
                self.activityIndicator.stopAnimating()
                
                print("Current Page" , self.current_page)
                self.isLoading = false
                if let articles = articles {
                    self.Articles.append(contentsOf: articles)
                    
                    self.tableView.reloadData()
                    self.current_page += 1
                    self.last_page = last_page!
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.Articles.count
        
    }
    
    
    
    /**
     Declare item height
     
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.00;//Choose your custom row height
    }
    /**
     parse test details data to test details screen
     
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        
        performSegue(withIdentifier: "EncyclopediaDetails", sender: self.Articles[indexPath.row])
        
    }
    /**
     navigate to test details screens
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dist = segue.destination as? EncyclopediaDetailsVC {
            if let Item = sender as? EncyclopediaModel {
                dist.Article = Item
                
                
            }
            
        }
        
    }
    
    
}


