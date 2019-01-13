//
//  ChatGroupVc.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class ChatGroupVc: BaseViewController  , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
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
    var ChatType : String! = "mychat"
    var ChatGroups = [MyGroupsModel]()
    var AllGroups = [AllGroupsModel]()
    lazy var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
        return refresher
    }()
    
    @IBOutlet weak var TableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var JoinChatTopConstraint: NSLayoutConstraint!
    
    var current_page :Int = 1
    var last_page : Int = 1
    var isLoading : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.title = "Group Chats"
        // self.navigationItem.setRightBarButtonItems([Notification], animated: true)
        
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refresher)
        
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
            ApiMethods.UpdateNotification(api_token: api_token, notification_Type: "chat", compltion: { (status, api_token_status, error ) in
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
        var count : Int!
        if self.ChatType == "mychat" {
            count = ChatGroups.count
        }else {
            count = AllGroups.count
        }
        return count
    }
    /**
     Declare cell type
     
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupCell") as! ChatGroupCell
        cell.selectionStyle = .none

          cell.GroupButton.addTarget(self, action: #selector(JoinGroupChat(sender:)), for: .touchUpInside)
        if self.ChatType == "mychat" {
            let group = ChatGroups[indexPath.row]
            cell.GroupButton.isHidden = true
        cell.ConfigureCell(Groups: group)
          
        }else {
            let group = AllGroups[indexPath.row]
            cell.GroupButton.isHidden = false

            cell.ConfigureJoin(Groups: group)
        }
        
        return cell
    }
    @objc func JoinGroupChat (sender : UIButton) {
        print("Button" , sender.tag)
        if let api_token = ApiToken.getApiToken() {
            ApiMethods.AskToGoinChatGroup(api_token: api_token, group_id: sender.tag, compltion: { (status, api_token_status, message, error ) in
                if api_token_status == true {
                    if error == nil {
                        if status == true {
                         
                            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                            let mylabel = UILabel(frame: CGRect(x: 10, y: 10, width: 250, height: 60))
                            mylabel.text = message
                            mylabel.textColor = .black
                            mylabel.adjustsFontSizeToFitWidth = true
                            mylabel.numberOfLines = 3
                           // alert.setValue(mylabel, forKey: "attributedMessage")
                            alert.view.addSubview(mylabel)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
        }
    }
    /**
     Load Items
     
     */
    @objc private func handelRefresh() {
        self.refresher.endRefreshing()
        guard !isLoading else {return}
        isLoading = true
        if let api_token = ApiToken.getApiToken() {
            
            ApiMethods.GetMyGroupsList(api_token: api_token) { (status,api_token_status,error ,groups , last_page) in
                self.activityIndicator.stopAnimating()
                
                self.isLoading = false
                if let groups = groups {
                    self.ChatGroups = groups
                    self.tableView.reloadData()
                    self.current_page = 1
                    self.last_page = last_page!
                }else {
                    let alert = UIAlertController(title: "", message: "There is no  chat group for you", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    @objc private func handelRefreshAllGroups() {
        self.refresher.endRefreshing()
        guard !isLoading else {return}
        isLoading = true
        if let api_token = ApiToken.getApiToken() {
            
            ApiMethods.GetAllChatGroups(api_token: api_token) { (status,api_token_status,error ,groups , last_page) in
                self.activityIndicator.stopAnimating()
                
                self.isLoading = false
                if let groups = groups {
                    self.AllGroups = groups
                    self.tableView.reloadData()
                    self.current_page = 1
                    self.last_page = last_page!
                }else {
                    let alert = UIAlertController(title: "", message: "There is no available chat", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
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
            
            ApiMethods.GetMyGroupsList(api_token: api_token, page: self.current_page+1) { (status,api_token_status,error ,groups , last_page) in
                self.activityIndicator.stopAnimating()
                
                print("Current Page" , self.current_page)
                self.isLoading = false
                if let groups = groups {
                    self.ChatGroups.append(contentsOf: groups)
                    
                    self.tableView.reloadData()
                    self.current_page += 1
                    self.last_page = last_page!
                }
            }
            
        }
    }
    func loadMoreAllGroups ()  {
        
        guard !isLoading else {return}
        guard current_page < last_page else {return}
        isLoading = true
        if let api_token = ApiToken.getApiToken() {
            
            ApiMethods.GetAllChatGroups(api_token: api_token, page: self.current_page+1) { (status,api_token_status,error ,groups , last_page) in
                self.activityIndicator.stopAnimating()
                
                print("Current Page" , self.current_page)
                self.isLoading = false
                if let groups = groups {
                    self.AllGroups.append(contentsOf: groups)
                    
                    self.tableView.reloadData()
                    self.current_page += 1
                    self.last_page = last_page!
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.ChatType == "mychat" {
        let count = self.ChatGroups.count
        if indexPath.row == count-1 {
            self.loadMore()
        }
        }else {
            let count = self.AllGroups.count
            if indexPath.row == count-1 {
                self.loadMoreAllGroups()
            }
        }
    
     
    }
    
    
    
    /**
     Declare item height
     
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.00;//Choose your custom row height
    }
    /**
     parse test details data to test details screen
     
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.ChatType == "mychat" {
            SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: ApiToken.GetItem(Key: "first_name") + " " + ApiToken.GetItem(Key: "last_name") , completionHandler: { (userList) -> Void in
              
            })
            performSegue(withIdentifier: "GoToChat", sender: self.ChatGroups[indexPath.row])
        }
        
    }
    /**
     navigate to test details screens
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dist = segue.destination as? ChatViewController {
            
                dist.nickname = ApiToken.GetItem(Key: "first_name") + " " + ApiToken.GetItem(Key: "last_name")
            if let item = sender as? MyGroupsModel {
                dist.groupId = item.group_id
                dist.ChatName = item.title
            }
                
            
            
        }
        
    }
    
    @IBAction func JoinChatActionBu(_ sender: UIButton) {
        self.ChatType = "joinchat"
        self.tableView.isHidden = false
      //   self.ChatGroups.removeAll()
        self.AllGroups.removeAll()
        self.tableView.reloadData()
        self.handelRefreshAllGroups()
       
        self.JoinChatTopConstraint.constant = 10.0
        self.TableViewTopConstraint.constant = 70.0
        
    }
    @IBAction func MyChatActionBu(_ sender: UIButton) {
        self.ChatType = "mychat"
        self.tableView.isHidden = false
        self.ChatGroups.removeAll()
        self.AllGroups.removeAll()
        self.tableView.reloadData()

        self.handelRefresh()
    
        self.JoinChatTopConstraint.constant = 350.0
        self.TableViewTopConstraint.constant = 10.0
    }
    
}


