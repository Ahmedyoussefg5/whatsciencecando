//
//  EncyclopediaShowPdf.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/10/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
import WebKit
class EncyclopediaShowPdf : UIViewController  , UIWebViewDelegate{
    var PdfLink : String!
    var Share : Int!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var PdfWeb: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.activityIndicator.startAnimating()
        PdfWeb.delegate = self

        self.LoadWebView() {(status) in
            print("Status" , status)
         //   self.activityIndicator.stopAnimating()
            
        }
        if self.Share == 0 {
            self.ShareButton.isHidden = true
            
        }
    }
    
    @IBAction func CloseActionBu(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func LoadWebView (compltion : @escaping (_ status : Bool?  )->Void) {
        let urlString = "http://docs.google.com/gview?embedded=true&url=" +  EncylopediaUrl + PdfLink
        if let url = URL(string: urlString) {
            print("Url" , url)
            let request = URLRequest(url: url)
            PdfWeb.loadRequest(request)
            
            compltion(true)
        }
    }
  
    
    @IBAction func ShareActionBu(_ sender: UIButton) {
        let activityVc = UIActivityViewController(activityItems: [ServerUrl  + "assets/files/encyclopedias/" +  PdfLink], applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = self.view
        self.present(activityVc, animated: true, completion: nil)
    }
}
