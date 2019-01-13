//
//  AskTheExpertVc.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class AskTheExpertVc: BaseViewController , UITableViewDelegate , UITableViewDataSource  {
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
    var Doctors = [AskTheExpertModel]()
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
        self.title = "Ask the expert"

        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

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
        return Doctors.count
    }
    /**
     Declare cell type
     
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AskTheExperCell") as! AskTheExperCell
        let doctor = Doctors[indexPath.row]
        cell.selectionStyle = .none

        cell.ConfigureCell(Doctor: doctor)
        
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

            ApiMethods.GetDoctorsList(api_token: api_token) { (status,api_token_status,error ,doctors , last_page) in
                self.activityIndicator.stopAnimating()

                self.isLoading = false
                if let doctors = doctors {
                    self.Doctors = doctors
                    self.tableView.reloadData()
                    self.current_page = 1
                    self.last_page = last_page!
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
            
            ApiMethods.GetDoctorsList(api_token: api_token, page: self.current_page+1) { (status,api_token_status,error ,doctors , last_page) in
                self.activityIndicator.stopAnimating()

                print("Current Page" , self.current_page)
                self.isLoading = false
                if let doctors = doctors {
                    self.Doctors.append(contentsOf: doctors)

                    self.tableView.reloadData()
                    self.current_page += 1
                    self.last_page = last_page!
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.Doctors.count
      
    }
    
    
    
    /**
     Declare item height
     
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200.0;//Choose your custom row height
    }
    /**
     parse test details data to test details screen
     
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        
        performSegue(withIdentifier: "SendMessageToDoctor", sender: self.Doctors[indexPath.row])
        
    }
    /**
     navigate to test details screens
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dist = segue.destination as? AskDoctorVc {
            if let Item = sender as? AskTheExpertModel {
               dist.DoctorData = Item
                
                
            }
            
        }
        
    }
 
    
}

