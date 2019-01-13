//
//  NewsLetterVC.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/4/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import YouTubePlayer
import Kingfisher
import PDFReader
class NewsLetterVC: BaseViewController, UIWebViewDelegate{
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
    @IBOutlet weak var PrevButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LowImageButton: UIButton!
    
    @IBOutlet weak var ViewContainer: UIView!
    var Months : String!
    var Photos : String!
    var Videos : String!
    var Links : String!
    var Low : String!
    var type : String!
    var pdfFile : String!
    var index = 0
    var player = AVPlayer()
    var playerController = AVPlayerViewController()
    var optionMenu = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        print("Image Data Trans" , self.Months)
        self.title = self.Months
        self.DateLabel.text = self.Months
        self.type = "low"
        self.LoadItem(i: 1 , type : "low")
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
    public func UpdateNotification (compltion : @escaping (_ status: Bool)->Void)  {
        if let api_token = ApiToken.getApiToken() {
            ApiMethods.UpdateNotification(api_token: api_token, notification_Type: "newsletter", compltion: { (status, api_token_status, error ) in
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
    func LoadItem (i : Int!  , type : String!) {
        print("Data" , Months)
        print("Load Item" , i)
      
        if self.Months != nil {
    
            if Photos != nil {
               print("View Conteainer" , self.ViewContainer.frame)
                let image = UIImageView()
                image.frame = CGRect(x: 0, y: 0, width: self.ViewContainer.frame.width, height: self.ViewContainer.frame.height)
               // image.translatesAutoresizingMaskIntoConstraints = false
                image.clipsToBounds = true
                
                print("Image Frame" , image.frame)
                //image.center = self.ViewContainer.center
               
                image.contentMode = .scaleAspectFill
                var url = URL(string: URL_IMAGE_PREFIX + Photos!)!
                self.LowImageButton.isHidden = false
                    print("Url" , url)
                if type == "high" {
                    print("Link Type " , self.type)
                       image.kf.setImage(with: url , placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }else {
                    print("Link Type " , self.type)

                    url = URL(string: URL_IMAGE_PREFIX + Low!)!
                     image.kf.setImage(with: url , placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
                }
             
                image.autoresizingMask = [.flexibleWidth , .flexibleHeight ,.flexibleTopMargin ,.flexibleLeftMargin , .flexibleBottomMargin ,.flexibleRightMargin]

                self.ViewContainer.addSubview(image)
            }else if  Links != nil {
                let VideoView = YouTubePlayerView()
                VideoView.frame = CGRect(x: 0, y: 0, width: self.ViewContainer.frame.width, height: self.ViewContainer.frame.height)

                print("Link" , String(describing: Links))
                let videoURL = URL(string: "https://www.youtube.com/watch?v=" + Links)!
                
                print("Video Url" , videoURL)
        VideoView.autoresizingMask = [.flexibleWidth , .flexibleHeight ,.flexibleTopMargin ,.flexibleLeftMargin , .flexibleBottomMargin ,.flexibleRightMargin]
                VideoView.loadVideoID(String(describing: Links!))
                self.ViewContainer.addSubview(VideoView)
      
            }else if Videos != nil {
                

                let videoURL = URL(string: URL_Video_PREFIX + Videos!)!
                
                let player = AVPlayer(url: videoURL)
                let vc = AVPlayerViewController()
                vc.player = player
                
                present(vc, animated: true) {
                    vc.player?.play()
                }
                
                /*
                let videoURL = URL(string: URL_Video_PREFIX + video!)!

                let player = AVPlayer(url: videoURL)
                let vc = AVPlayerViewController()
                vc.player = player
                
                present(vc, animated: true) {
                    vc.player?.play()
                }
 */
                /*
                for view in self.VideoView.subviews {
                    view.removeFromSuperview()
                }
                self.VideoView.layer.sublayers = nil

                var height  =  self.VideoView.frame.size.height
                var width  =  self.VideoView.frame.size.width
                let videoURL = URL(string: URL_Video_PREFIX + video!)!
                
                let player = AVPlayer(url: videoURL)
                let playerLayer = AVPlayerLayer(player: player)
              //  playerLayer.frame = CGRect(x: 0, y: 0, width: width , height: height)
                self.VideoView.layer.addSublayer(playerLayer)
                player.play()

      */

            }else if self.pdfFile != nil {
                /*
                let remotePDFDocumentURLPath = NewsLetterPdfLink + pdfFile!
                
                let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
                guard let document = PDFDocument(url: remotePDFDocumentURL) else{
                   
                    return
                }
                
                let readerController = PDFViewController.createNew(with: document)
                //self.ViewContainer.addSubview(readerController)
                self.navigationController?.pushViewController(readerController, animated: true)
 */
                
                let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.ViewContainer.frame.width, height: self.ViewContainer.frame.height))
                webView.delegate = self
                if let url = URL(string: "http://docs.google.com/gview?embedded=true&url=" + NewsLetterPdfLink + pdfFile) {
                    print("Url" , url)
                    let request = URLRequest(url: url)
                    webView.loadRequest(request)
                    webView.autoresizingMask = [.flexibleWidth , .flexibleHeight ,.flexibleTopMargin ,.flexibleLeftMargin , .flexibleBottomMargin ,.flexibleRightMargin]
                    
                    self.ViewContainer.addSubview(webView)
                    
                }
  
            }

            
        }
    }

    @IBAction func NextButtonAction(_ sender: Any) {
       
    }
    
    @IBAction func PrevButtonAction(_ sender: UIButton) {
    
    }
    
     @IBAction func LowActionBu(_ sender: UIButton) {
        print("Image Type " , self.type)
        if self.type == "low" {
           self.type = "high"
            print("Image Type 2 " , self.type)

            sender.setTitle("Show in high resolution", for: .normal)
           
            LoadItem(i: 1, type: self.type)
        }else {
            print("Image Type 3 " , self.type)

             self.type = "low"
            sender.setTitle("Show in low resolution", for: .normal)
           
            LoadItem(i: 1, type: self.type)

        }
        
    }
    func PlayVideo () {
        
    }
    

}
