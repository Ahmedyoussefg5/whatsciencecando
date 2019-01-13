//
//  FAQVC.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/3/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import MessageUI

class FAQVC: UITableViewController ,MFMailComposeViewControllerDelegate{
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
    @IBOutlet weak var menuButton: UIBarButtonItem!
    lazy var errorView = ConnectionErrorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        self.tableView.contentInset = UIEdgeInsetsMake(94, 0, 0, 0)

        self.constructConnectionErrorView()
        getData()
        
        if self.revealViewController() != nil {
            revealViewController().rightViewController = nil
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
    }
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            call(tel: "012230304412")
        }else{
            sendEmail()
        }
    }
    
    func call(tel:String)  {
        if let url = URL(string: "tel://"+tel), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    
    func getData() {
        self.errorView.isHidden = true
    }
    
    func constructConnectionErrorView() {
        if !self.view.subviews.contains(errorView){
            errorView.frame = self.view.frame
            self.view.addSubview(errorView)
            self.errorView.tryAgainBtn.addTarget(self, action: #selector(reload), for: .touchUpInside)
        }
    }
    
    func sendEmail() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["medinfo-Egypt@astrazeneca.com"])
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}
