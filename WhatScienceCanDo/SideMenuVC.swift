//
//  SideMenuVC.swift
//  Obesity Egypt
//
//  Created by Ahmed on 8/20/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import Kingfisher

class SideMenuVC: UITableViewController {
    
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var userTitleLabel: UILabel!
    
    
    let youtubeId = "TheNancygobran"
    
    override func viewDidLoad() {
        revealViewController().rearViewRevealWidth = 250
        revealViewController().rightViewRevealWidth = 250
        clearsSelectionOnViewWillAppear = true
        print("User Id" ,CURRENT_USER?.id )

        guard let userId = CURRENT_USER?.id else{
            return 
        }
        userTitleLabel.text = "\((CURRENT_USER?.first_name!)!) \((CURRENT_USER?.last_name!)!)"
        
        let url = URL(string: SP_ImageUrl  + (CURRENT_USER?.image!)!)
        print("Photo Url " , url)
        self.userImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "avatarmale"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
            DispatchQueue.main.async {
                self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
            }
        })

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "NewsLetter"?:
            showEventsCalendar = false
        default:
            showEventsCalendar = true
        }
            
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "logout"{
            return true
        }else{
            let storyboard  = UIStoryboard(name: "SignIn_Up", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "rootLogin")
            userData.removeObject(forKey: "ID")
            userData.removeObject(forKey: "user_id")
            userData.removeObject(forKey: "api_token")
            self.present(vc, animated: true, completion: nil)
            return false
        }
    }
    
}
