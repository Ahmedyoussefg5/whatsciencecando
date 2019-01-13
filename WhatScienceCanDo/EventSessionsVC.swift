//
//  EventSessionsVC.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/6/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import PopupDialog

class EventSessionsVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nodataLabel:UILabel!
    
    var ID:Int!
    var sessions = [Session]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
            
        }
    }
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    override func getData() {
        super.getData()
        RequestManager.defaultManager.getSessionsForEventWithID(ID: ID) { (error, sessions, recError) in
            print(error)
            if !error{
                self.sessions = sessions!
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    
                    if self.sessions.count == 0 {
                        self.tableView.isHidden = true
                        self.nodataLabel.isHidden = false
                    }else{
                        self.tableView.isHidden = false
                        self.nodataLabel.isHidden = true
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = sessions[indexPath.row].name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopViewVC") as! PopViewVC
        vc.session = sessions[indexPath.row]
        let popup = PopupDialog(viewController: vc)
        self.present(popup, animated: true, completion: nil)
    }
        
}
