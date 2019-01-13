//
//  RegistrationVC.swift
//  Obesity Egypt
//
//  Created by Ahmed on 8/8/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import CZPicker
import Kingfisher
import SwiftValidator

class RegistrationVC: BaseViewController ,UITextFieldDelegate,ValidationDelegate{
    
    let validator = Validator()

    @IBOutlet var errorLabels: [UILabel]!
    
    @IBOutlet weak var ActivationCode: DesignableUITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!

    @IBOutlet weak var specialityTextfield: UITextField!

    @IBOutlet weak var signupBtn: UIButton!
    
    var specialities = [BaseModel]()
//    var specialitiesImages = [UIImage]()
    var pickerWithImage: CZPickerView?
    
    var selectedSpecialityID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        self.hideKeyboardWhenTappedAround()
        
        validateTextFields()
    }
    
    override func getData() {
        self.errorView.isHidden = true

        RequestManager.defaultManager.getSpecialities { (error, specialities, recError) in
            
            if !error{
                self.specialities = specialities!
                
                DispatchQueue.main.async {
                    for spec in self.specialities {
                        let url = URL(string: URL_IMAGE_PREFIX + (spec.image)!)
                        let imageView = UIImageView()
                        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "pressrelease"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
                        }, completionHandler: { image, error, cacheType, imageURL in
                        })
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === specialityTextfield {
            self.showWithImages(sender: textField)
        }
    }
    
    
    @IBAction func showWithImages(sender: AnyObject) {
        pickerWithImage = CZPickerView(headerTitle: "Specialities", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        
        pickerWithImage?.headerBackgroundColor = appGold
        pickerWithImage?.delegate = self
        pickerWithImage?.dataSource = self
        pickerWithImage?.needFooterView = false
        pickerWithImage?.show()
    }

}



extension RegistrationVC: CZPickerViewDelegate, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return specialities.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        if pickerView == pickerWithImage {
            let url = URL(string: SP_ImageUrl + (specialities[row].image)!)!
            print("Image Url" , url)
            let imageView = UIImageView()
            imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "pressrelease"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
            }, completionHandler: { image, error, cacheType, imageURL in
            })

            return imageView.image
        }
        return nil
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return specialities[row].name!
    }

    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        print(specialities[row])
        specialityTextfield.text = specialities[row].name!
        selectedSpecialityID = specialities[row].id!
    }
    
    // ValidationDelegate methods
    
    func validationSuccessful() {
        // submit the form
        print("Success")
        self.activityIndicator.startAnimating()
        
        RequestManager.defaultManager.signupWithEmail(email: emailTextfield.text!, activation: self.ActivationCode.text!, password: passwordTextfield.text!, phoneNumber: phoneTextfield.text!, firstName: firstNameTextfield.text!, lastName: lastNameTextfield.text!, specialityID: selectedSpecialityID) { (error, recError) in
            print(error)
            if !error{
                if recError?.code == .Success {
                    let alert = UIAlertController(title: (recError?.type!)!, message: (recError?.desc!)!, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        let storyboard  = UIStoryboard(name: "SignIn_Up", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                        self.present(vc, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
        }
    }
    
    func validateTextFields() {
        
        validator.registerField(firstNameTextfield,errorLabel: errorLabels[0], rules: [RequiredRule()])
        
        validator.registerField(lastNameTextfield,errorLabel: errorLabels[1], rules: [RequiredRule()])
        
        validator.registerField(emailTextfield,errorLabel: errorLabels[2], rules: [RequiredRule(),EmailRule(message: "Invalid email")])
        
        validator.registerField(phoneTextfield,errorLabel: errorLabels[3], rules: [RequiredRule(),PhoneNumberRule()])
        
        validator.registerField(passwordTextfield,errorLabel: errorLabels[4], rules: [RequiredRule(), PasswordRule()])
        
        validator.registerField(specialityTextfield,errorLabel: errorLabels[5], rules: [RequiredRule()])
        
        validator.registerField(confirmTextfield, errorLabel: errorLabels[6], rules: [RequiredRule(),ConfirmationRule(confirmField: passwordTextfield)])
        validator.registerField(ActivationCode, errorLabel: errorLabels[7], rules: [RequiredRule()])
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (_, error) in errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
        self.showAlertWithTitle(title: "Failed", message: "please fill all the mandatory fields")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validator.validateField(textField) { (error) in
            if error != nil {
                error?.errorLabel?.text = error?.errorMessage
                error?.errorLabel?.isHidden = false
            }else{
                
                errorLabels[textField.tag].isHidden = true
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        validator.validate(self)
    }
}

