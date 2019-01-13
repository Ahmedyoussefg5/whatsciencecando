//
//  LoginVC.swift
//  Obesity Egypt
//
//  Created by Ahmed on 8/8/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
        
    
    @IBOutlet weak var RememberMeButton: UIButton!
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        RememberMeButton.titleLabel!.adjustsFontSizeToFitWidth = true
        forgetPasswordButton.titleLabel!.adjustsFontSizeToFitWidth = true
       if let api_token = ApiToken.getApiToken() {
        CURRENT_USER = User()

      
        print("User Id Data" , ApiToken.GetItem(Key: "user_id"))
            

        

        if (ApiToken.GetItem(Key: "user_id") != nil && ApiToken.GetItem(Key: "user_id") != "") {
            CURRENT_USER?.id = Int(ApiToken.GetItem(Key: "user_id"))

        //    CURRENT_USER?.id = Int(ApiToken.GetItem(Key: "user_id"))
            CURRENT_USER?.first_name = ApiToken.GetItem(Key: "user_first_name")
                print("first_name" , CURRENT_USER?.first_name)
            CURRENT_USER?.last_name = ApiToken.GetItem(Key: "user_last_name")

            CURRENT_USER?.email = ApiToken.GetItem(Key: "user_email")

            CURRENT_USER?.mobile = ApiToken.GetItem(Key: "user_mobile")

            CURRENT_USER?.image = ApiToken.GetItem(Key: "user_image")
            CURRENT_USER?.speciality?.name = ApiToken.GetItem(Key: "user_specialtiy")
            CURRENT_USER?.speciality?.id = Int(ApiToken.GetItem(Key: "speciality_id"))

            if let token = userData.value(forKey: "OneSignalToken") as? String{
                ACCESS_TOKEN = token
            }
          //  RequestManager.defaultManager.AddOneSignalToken(token: ApiToken.GetItem(Key: "OneSignalToken"))
            RequestManager.defaultManager.sendDeviceToken(compilition: { (error, recError) in
                print("Notification Error" , error)
            })
            DispatchQueue.main.async {
                let storyboard  = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "rootHome")
                self.present(vc, animated: true)
            }
        
        }
    }
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func getData() {
        self.errorView.isHidden = true
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        if emailTextfield.text! != "" && passwordTextfield.text! != ""{
            sendLoginRequest()
        }else{
            self.showAlertWithTitle(title: "Failed", message: "Please Fill The Fields Correctly")
            activityIndicator.stopAnimating()
        }
    }
    
    
    @IBAction func RemmberMeAction(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "UnCheck") {
            sender.setImage(#imageLiteral(resourceName: "Check"), for: .normal)
        }else {
              sender.setImage(#imageLiteral(resourceName: "UnCheck"), for: .normal)
        }
    }
    func sendLoginRequest() {
        activityIndicator.startAnimating()
        RequestManager.defaultManager.loginWithemail(email: emailTextfield.text!, password: passwordTextfield.text!) { (status, error) in
            if error == nil {
                if status == true {
                    let storyboard  = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "rootHome")
                    self.present(vc, animated: true)
                }else {
                    let alert = UIAlertController(title: "Failed", message: "Please Check Your email and password ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.viewDidLoad()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
                self.errorView.isHidden = false
                self.activityIndicator.stopAnimating()

            }
            /*
                if (recError?.code!) == .Success{
                    DispatchQueue.main.async {
                        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "rootHome")
                        self.present(vc, animated: true)
                    }
                }else{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Failed", message: (recError?.desc!)!, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            self.viewDidLoad()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
 */
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: URL_IMAGE_PREFIX + "/password/reset")!, options: [:], completionHandler: nil)

//        DispatchQueue.main.async {
//            let alertController = UIAlertController(title: "Forgot Password", message: "Enter Your E-Mail", preferredStyle: .alert)
//
//            let confirmAction = UIAlertAction(title: "Send", style: .default) { (_) in
//                let field = alertController.textFields![0]
//                if field.text! != ""{
//                    self.email = field.text!
//                    RequestManager.defaultManager.sendPasswordForUserWithEmail(email: field.text!, compilition: { (error, recError) in
//                        print(error)
//                        if !error{
//                            if recError?.code == .Success{
//                                self.showAlertWithTitle(title: "Suucess", message: (recError?.desc!)!)
//                            }
//                        }
//                        else{
//                            self.showAlertWithTitle(title: "Failed", message: "Error In Connection\n please try again later")
//                        }
//                    })
//                }
//
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//
//            alertController.addTextField { (textField) in
//                textField.placeholder = "Email"
//            }
//            alertController.addAction(confirmAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
    }
}
