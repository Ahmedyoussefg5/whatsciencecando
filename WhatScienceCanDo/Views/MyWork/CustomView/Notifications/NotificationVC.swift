//
//  NotificationVC.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/24/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
/// Declare User Notifications
class NotificationVc: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    lazy var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
        return refresher
    }()
    lazy var Back : UIBarButtonItem = {
        let image = UIImage(named : "Notification")
        
        let Back = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(BackFunction))
        return Back
    }();
    var current_page :Int = 1
    var last_page : Int = 1
    var isLoading : Bool = false
    var Tests = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButtonItems([Back], animated: true)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        let test = Tests[indexPath.row]
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
        return 90.00;//Choose your custom row height
    }
    
    
    
}

