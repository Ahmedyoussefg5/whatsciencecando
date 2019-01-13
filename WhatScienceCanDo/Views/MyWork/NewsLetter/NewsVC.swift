//
//  NewsVC.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/24/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation
import PDFReader
class NewsVC: BaseViewController , UITableViewDelegate , UITableViewDataSource {
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
    @IBOutlet weak var NoDataLabel: UILabel!
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
    var index = 0
    var MonthsKeys = [String]()
    var NewsDict = [String:JSON]()
    var optionMenu = UIAlertController()

    @IBOutlet weak var PrevButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var DateLabel: UILabel!
    var current_page :Int = 1
    var last_page : Int = 1
    var isLoading : Bool = false
    var NewsLetters = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Newsletter"
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refresher)
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)
        self.UpdateNotification()
        handelRefresh()
        // Do any additional setup after loading the view.
    }
    public func UpdateNotification () {
        if let api_token = ApiToken.getApiToken() {
            ApiMethods.UpdateNotification(api_token: api_token, notification_Type: "newsletter", compltion: { (status, api_token_status, error ) in
                if error == nil {
                    if status == true {
                        if api_token_status == true {
                            
                        }
                    }
                }
            })
        }
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
        return NewsLetters.count
    }
    /**
     declare cell
     
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        cell.selectionStyle = .none

        let news = NewsLetters[indexPath.row]
        cell.ConfigureCell(News: news)
        
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
            ApiMethods.GetNewsLetter(api_token: api_token, compltion: { (status, api_token_status, news, error) in
                if error == nil {
                    if status == true {
                        if api_token_status == true {
                            self.activityIndicator.stopAnimating()
                            if var news = news {
                                let df = DateFormatter()
                                let CurrentDate = Date()
                                df.dateFormat = "yyyy-MM"
                                let result = df.string(from: CurrentDate)
                                print("Result" , result)
                                let sortedArrayOfDicts = news
                                    //First map to an array tuples: [(Date, [String:Int]]
                                    .map{(df.date(from: $0.key)!, [$0.key:$0.value])}
                                    
                                    //Now sort by the dates, using `<` since dates are Comparable.
                                    .sorted{$0.0 < $1.0}
                                    
                                    //And re-map to discard the Date objects
                                    .map{$1}
                                
                                print(" NewsLetter JSOn :", sortedArrayOfDicts)
                                for new in 0...sortedArrayOfDicts.count - 1{
                                    let key = sortedArrayOfDicts[new].first?.key
                                    let value = sortedArrayOfDicts[new].first?.value
                                    if key == result {
                                        self.index = new
                                    }
                                  //  News.updateValue(value!, forKey: key!)
                                    print("Values " , value)
                                    // News[key!] = value
                                    self.NewsDict.updateValue(value!, forKey: key!)
                                   
                                    self.MonthsKeys.append(key!)
                                    for x in value! {
                                        
                                        let newsobj = NewsModel(Single: x.1.dictionary!)
                                        
                                        self.NewsLetters.append(newsobj)
                                    }
                                    
                                }
                                print("Months Keys" , self.MonthsKeys)
                           
                               /*
                                for new in news {
                                    self.NewsDict.updateValue(new.value, forKey: new.key)
                                     let obj = new.key
                                    self.MonthsKeys.append(obj)
                                    for x in news[obj]! {

                                        let newsobj = NewsModel(Single: x.1.dictionary!)
                                     
                                        self.NewsLetters.append(newsobj)
                                    }
                                }
                           */
                                self.LoadItem(index: self.index)
                                // self.tableView.reloadData()
                                self.current_page = 1
                            }
                        }
                    }
                }
                
            /*
                 
                 self.isLoading = false
                 if let tests = tests {
                 self.Tests = tests
                 self.tableView.reloadData()
                 self.current_page = 1
                 self.last_page = last_page!
                 }
                 */
            })
       
        }
    }
    /**
     load more data
     
     */
    func loadMore ()  {
        
        guard !isLoading else {return}
        guard current_page < last_page else {return}
        isLoading = true
        /*
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
        */
    }
    /**
     check if there is more data
     
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.NewsLetters.count
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
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    func LoadItem (index : Int) {
        self.NoDataLabel.isHidden = true
        if self.MonthsKeys.count >= 1 {
            if (index >= 0) && (index <  self.MonthsKeys.count )  {
                print("Index" , index)
        let item = self.MonthsKeys[index]
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM"
        let date = formatter.date(from: item)
        formatter.dateFormat = "yyyy MMMM"
        self.DateLabel.text = formatter.string(from: date!)
        var items = [NewsModel]()
        for x in NewsDict[item]! {
            
            let newsobj = NewsModel(Single: x.1.dictionary!)
            
            items.append(newsobj)
        }
        self.NewsLetters = items
        self.tableView.reloadData()
        }
        }
        if self.NewsLetters.count == 0 {
            self.NoDataLabel.isHidden = false

        }
    }
    
    @IBAction func NextButtonAction(_ sender: Any) {
       print("Months Labels" , self.MonthsKeys)
        if self.MonthsKeys.count > (index) {
          index = index + 1
            
            self.LoadItem(index: index)
           
        }
        print("Index Count" , self.index)
    }
    
    @IBAction func PrevButtonAction(_ sender: UIButton) {
        index = index - 1

        if self.index >= 0 {
            self.LoadItem(index: index)
            
        }else {
            
            index = 0
        }
    }
    //NewsletterDetails
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewsCell
        performSegue(withIdentifier: "NewsletterDetails", sender: self.NewsLetters[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? NewsLetterVC {
            if let Item = sender as? NewsModel {
                 dist.Months = Item.name
                 dist.Photos = Item.image
                dist.Videos  = Item.video
                 dist.Links = Item.link
                dist.Low = Item.lowImage
                dist.pdfFile = Item.pdfLink
                
            }
            
        }
    }
}

