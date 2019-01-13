//
//  HomeVC.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/3/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import FSCalendar
import Kingfisher
import PDFReader
import Agrume
class EventsVC: BaseViewController , FSCalendarDataSource, FSCalendarDelegate,UITableViewDelegate,UITableViewDataSource{
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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var noDataView:UIView!
    @IBOutlet weak var errorTitleLabel:UILabel!
    
    var events = [Event]()
    var optionMenu = UIAlertController()
    var selectedDate = Date()
    var selectedEvent : Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

        calendarView.daysContainer.isHidden = true
        calendarView.weekdayHeight = 0
        calendarView.delegate = self
        
        self.title = showEventsCalendar ? "Events Calendar" : "NewsLetter"
        
        self.errorTitleLabel?.text = showEventsCalendar ? "No Events Available" : "No Newsletter Available"
    }
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
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
    public func UpdateNotification (compltion : @escaping (_ status: Bool)->Void){
        if let api_token = ApiToken.getApiToken() {
            ApiMethods.UpdateNotification(api_token: api_token, notification_Type: "event", compltion: { (status, api_token_status, error ) in
                if error == nil {
                    if status == true {
                        if api_token_status == true {
                            
                        }
                    }
                }
            })
        }
    }
    
    override func getData() {
        super.getData()
        
        RequestManager.defaultManager.getEventsWith(date: selectedDate.getStringFromDate(), forEvents: showEventsCalendar) { (error, events, recError) in
            print(error)
            print("Date" , self.selectedDate.getStringFromDate())
            if !error{
                
                self.events = events!
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    
                    if events?.count == 0 {
                        self.noDataView.isHidden = false
                    }else{
                        self.noDataView.isHidden = true
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventsInfoVC , segue.identifier == "gotoDetails" {
            vc.event = selectedEvent!
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("Changed")
        selectedDate = calendar.currentPage
        self.getData()
    }
    
    @IBAction func nextPage(){
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: 1, to: calendarView.currentPage)
        calendarView.currentPage = date!
    }
    
    @IBAction func prevPage(){
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: -1, to: calendarView.currentPage)
        calendarView.currentPage = date!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        let event = events[indexPath.row]
        print("Event Name : " , event.eventName)
        cell.titleLabel?.text = event.eventName!
        cell.eventImageView?.tintColor = appRed
        if event.startDate != "" {
          //  cell.subtitleLabel?.text = "\(event.startDate!) - \(event.endDate!)"
        }else{         
          //  cell.subtitleLabel?.text = event.endDate!
        }
        let url = URL(string: SP_ImageUrl + (event.image!))
        cell.eventImageView?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "pressrelease"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
            cell.eventImageView?.contentMode = .scaleAspectFit
        })

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !showEventsCalendar {
            optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cell = tableView.cellForRow(at: indexPath)
            let event = events[indexPath.row]
            
            if event.fileUrl != ""{
                optionMenu.popoverPresentationController?.sourceView = cell
                    let tel = UIAlertAction(title: "File", style: .default) { (UIAlertAction) in
                        DispatchQueue.main.async {
                            self.activityIndicator.startAnimating()
                            let remotePDFDocumentURLPath = SP_ImageUrl + (event.fileUrl!)
                        
                            let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
                            guard let document = PDFDocument(url: remotePDFDocumentURL) else{
                                self.activityIndicator.stopAnimating()
                                return
                            }
                            
                            let readerController = PDFViewController.createNew(with: document)
                            self.navigationController?.pushViewController(readerController, animated: true)
                            self.activityIndicator.stopAnimating()
                        }

                    }
                optionMenu.addAction(tel)
            }
            
            if event.image != ""{
                optionMenu.popoverPresentationController?.sourceView = cell
                let tel = UIAlertAction(title: "Image", style: .default) { (UIAlertAction) in
                    let url = URL(string: SP_ImageUrl + (event.image!))
                    UIImageView().kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
                    }, completionHandler: { image, error, cacheType, imageURL in
                        if let image = image {
                            let agrume = Agrume(image: image)
                            agrume.showFrom(self)
                        }
                    })


                    
                }
                optionMenu.addAction(tel)
            }
            
            if event.videoUrl != ""{
                optionMenu.popoverPresentationController?.sourceView = cell
                let tel = UIAlertAction(title: "External Link", style: .default) { (UIAlertAction) in
                    UIApplication.shared.open(URL(string:  (event.videoUrl!))!, options: [:], completionHandler: nil)
                }
                optionMenu.addAction(tel)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            
            optionMenu.view.tintColor = appRed
            self.present(optionMenu, animated: true, completion: nil)
        }else{
            self.selectedEvent = events[indexPath.row]
            self.performSegue(withIdentifier: "gotoDetails", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
}
