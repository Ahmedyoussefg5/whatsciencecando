//
//  ForgetPasswordVC.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/30/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import UIKit

class ForgetPasswordVC: BaseViewController {

    @IBOutlet weak var EmailAddressText: DesignableUITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
    }

    @IBAction func ResetPasswordActionBu(_ sender: UIButton) {
        guard let email = self.EmailAddressText.text , !email.isEmpty else {return}
        ApiMethods.ResetPassword(email: self.EmailAddressText.text!) { (status, msg, error) in
            if error == nil {
                if status == true {
                    let alert = UIAlertController(title: "", message: "Please check your email", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    let alert = UIAlertController(title: "", message: "Please enter correct email", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler:nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
