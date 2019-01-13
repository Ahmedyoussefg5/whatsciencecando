//
//  EncyclopediaDetailsVC.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/10/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class EncyclopediaDetailsVC: BaseViewController {
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
    @IBOutlet weak var ShowPdfButton: UIButton!
    @IBOutlet weak var ArticleDetails: UITextView!
    @IBOutlet weak var ArticleTitle: UILabel!
    var Article : EncyclopediaModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

        ConfigureView(Article: Article)
        self.activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
    }

  
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    @IBAction func ShowPdfActionBu(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowPdf") as! EncyclopediaShowPdf
        vc.PdfLink = self.Article.pdfLink
        vc.Share = self.Article.share
        self.present(vc, animated: true, completion: nil)
    }
    
    func ConfigureView(Article : EncyclopediaModel) {
        print("Article" , Article.share)
        self.ArticleTitle.text = Article.title
        self.ArticleDetails.text = Article.content
       // if Article.share == 0 {
          //  self.ShowPdfButton.isHidden = true
       // }
    }

}
