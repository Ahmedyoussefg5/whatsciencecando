//
//  AskDoctorVc.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/5/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit
import Foundation

import Kingfisher
class AskDoctorVc: BaseViewController {
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
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var SubjectField: UITextField!
    @IBOutlet weak var DoctorImage: UIImageView!
    
    @IBOutlet weak var DoctorDecription: UITextView!
    @IBOutlet weak var YourQuestion: UITextField!
    @IBOutlet weak var YourEmail: UITextField!
    @IBOutlet weak var DoctorName: UILabel!
    
    @IBOutlet weak var ContainerView: UIView!
    var DoctorData : AskTheExpertModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ask the expert"

        self.activityIndicator.stopAnimating()
       self.roundTopCornersRadius(view: self.SubjectField, radius: 20.0)
        self.roundTopCornersRadius(view: self.YourEmail, radius: 20.0)
        self.roundTopCornersRadius(view: self.YourQuestion, radius: 20.0)
        if (DoctorData.first_name != nil) && DoctorData.last_name != nil {
             self.DoctorName.text =  DoctorData.first_name + " " + DoctorData.last_name
        }
       self.DoctorDecription.text = DoctorData.description
        if DoctorData.image != nil {
        DoctorImage.layer.cornerRadius = DoctorImage.frame.size.height/2.0
        DoctorImage.clipsToBounds = true
            let url = URL(string: ServerUrl + DoctorData.image!)!
        
        self.DoctorImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        self.navigationItem.setRightBarButtonItems([Notifications], animated: true)

    }
    @objc func NotifictionFunction() {
        print("Notifications")
        //NotificationView
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") else { return }
        
        self.navigationController?.pushViewController(myVC, animated: true)
    }

    func roundCorners(view : UIView ,corners:UIRectCorner, radius:CGFloat) {
        /*
        let bounds = view.bounds
        
       // let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = UIColor.white.cgColor
        frameLayer.fillColor = nil
        
        view.layer.addSublayer(frameLayer)
 */
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        
        view.layer.backgroundColor = UIColor.white.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        view.layer.mask = rectShape
    }
    
    func roundTopCornersRadius(view : UIView ,radius:CGFloat) {
        let path = UIBezierPath(roundedRect: self.ContainerView.bounds  , byRoundingCorners: [.topRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
        //self.roundCorners(view: view ,corners: [ UIRectCorner.topRight], radius:radius)

    }
    
    @IBAction func SaveActionBu(_ sender: UIButton) {
        if let api_token = ApiToken.getApiToken() {
            guard let subject = self.SubjectField.text ,!subject.isEmpty else {
                let alert = UIAlertController(title: "", message: "Subject field is required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            guard let youremail = self.YourEmail.text ,!youremail.isEmpty else {
                let alert = UIAlertController(title: "", message: "Your email field is required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            guard let yorQuestion = self.YourQuestion.text ,!yorQuestion.isEmpty else {
                let alert = UIAlertController(title: "", message: "Your question field is required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
            
            
            //// Method To Server
            print("Doctor" , self.DoctorData.id)
            ApiMethods.SendQuestionToDoctor(api_token: api_token, doctor_id: self.DoctorData.id, subject: self.SubjectField.text!, email: self.YourEmail.text!, message: self.YourQuestion.text!, compltion: { (status, api_token_status, message, error ) in
                
                if error == nil {
                    if api_token_status == true {
                        if status == true {
                            let alert = UIAlertController(title: "", message: "Message sent successfully \n  A reply will be sent to your email", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else {
                    // Need To Be Updated to = Please try again later
                    let alert = UIAlertController(title: "", message: "A reply will be sent to your email", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
        }
    }
    
}
