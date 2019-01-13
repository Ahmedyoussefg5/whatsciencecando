//
//  PopViewVC.swift
//  Obesity Egypt
//
//  Created by Ahmed on 8/21/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import Kingfisher

class PopViewVC: UIViewController {

    @IBOutlet weak var sessionNameLabel: UILabel!
    @IBOutlet weak var instructorImageView: UIImageView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var firstInfoLabel: UILabel!
    @IBOutlet weak var secondInfoLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    
    var session :Session!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sessionNameLabel.text = session.name!
        self.instructorLabel.text = session.instructor?.name!
        
        let url = URL(string: URL_IMAGE_PREFIX + (session.instructor?.image)!)
        self.instructorImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "avatarmale"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
            self.instructorImageView.layer.cornerRadius = self.instructorImageView.frame.height / 2
        })

        self.firstInfoLabel.text = session.start_time!
        self.secondInfoLabel.text = session.end_time!
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
