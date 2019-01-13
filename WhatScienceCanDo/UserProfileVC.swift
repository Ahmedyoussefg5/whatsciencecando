//
//  UserProfileVC.swift
//  Obesity Egypt
//
//  Created by Ahmed on 9/11/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileVC: BaseViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileVC.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setData()
    }
    
    @IBAction func rotated() {
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
    }
    
    override func getData() {
        super.getData()
        
        RequestManager.defaultManager.getUserProfile { (error, recError) in
            print(error)
            if !error{
                self.setData()
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
        }
    }
    
    func setData() {
        guard let _ = CURRENT_USER else{
            return
        }
        DispatchQueue.main.async {
            self.usernameLabel.text = "\((CURRENT_USER?.first_name!)!)  \((CURRENT_USER?.last_name!)!)"
            print((CURRENT_USER?.first_name!)! + " " + (CURRENT_USER?.last_name!)!)
            self.emailLabel.text = (CURRENT_USER?.email!)!
            self.mobileLabel.text = (CURRENT_USER?.mobile!)!
            print((CURRENT_USER?.mobile!)!)
            
            self.specialityLabel.text = (CURRENT_USER?.speciality?.name!) ?? ""
            
            let url = URL(string: SP_ImageUrl  + (CURRENT_USER?.image!)!)
            self.backGroundImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "avatarmale"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
            }, completionHandler: { image, error, cacheType, imageURL in
                self.userImageView.image = image
                self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
            })
        }
    }
}
