//
//  EditProfileVC.swift
//  Obesity Egypt
//
//  Created by Ahmed on 9/11/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import SwiftValidator
import Kingfisher
import CZPicker

class EditProfileVC: BaseViewController ,ValidationDelegate,UITextFieldDelegate{

    @IBOutlet weak var userImageView : UIImageView!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var secondNameTextfield: UITextField!
    @IBOutlet weak var secondNameErrorLabel: UILabel!
    @IBOutlet weak var mobileTextfield: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var mobileErrorLabel: UILabel!
    @IBOutlet weak var specialityTextfield: UITextField!
    @IBOutlet weak var specialityErrorLabel: UILabel!
    
    @IBOutlet weak var updateBtn : UIButton!
    
    var imagePicker = UIImagePickerController()
    
    let validator = Validator()
    var toolBar = UIToolbar()
    
    var specialities = [BaseModel]()
    var pickerWithImage: CZPickerView?
    
    var selectedSpecialityID = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }

        firstNameTextfield.delegate = self
        secondNameTextfield.delegate = self
        mobileTextfield.delegate = self
        specialityTextfield.delegate = self
        imagePicker.delegate = self
        
        validator.registerField(firstNameTextfield,errorLabel: firstNameErrorLabel, rules: [RequiredRule()])
        validator.registerField(secondNameTextfield,errorLabel: secondNameErrorLabel, rules: [RequiredRule()])
        validator.registerField(mobileTextfield,errorLabel: mobileErrorLabel, rules: [RequiredRule()])
        validator.registerField(emailTextfield,errorLabel: emailErrorLabel, rules: [RequiredRule()])
        validator.registerField(specialityTextfield,errorLabel: specialityErrorLabel, rules: [RequiredRule()])
        
        DispatchQueue.main.async {
            self.setData()
            
        }
    }
    
    override func getData() {
        super.getData()
        
        RequestManager.defaultManager.getSpecialities { (error, specialities, recError) in
            
            if !error{
                self.specialities = specialities!
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    for spec in self.specialities {
                        let url = URL(string: SP_ImageUrl + (spec.image)!)
                        let imageView = UIImageView()
                        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "pressrelease"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
                        }, completionHandler: { image, error, cacheType, imageURL in
                        })
                        
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = true
                }
            }
        }
    }

    
    func setData() {
        firstNameTextfield.text = CURRENT_USER?.first_name!
        secondNameTextfield.text = CURRENT_USER?.last_name!
        mobileTextfield.text = CURRENT_USER?.mobile!
        emailTextfield.text = CURRENT_USER?.email!
        if CURRENT_USER?.speciality != nil {
            specialityTextfield.text = CURRENT_USER?.speciality?.name!
            selectedSpecialityID = (CURRENT_USER?.speciality?.id!)!
        }
        let url = URL(string: SP_ImageUrl + (CURRENT_USER?.image!)!)
        self.userImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "avatarmale"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
            self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
        })

    }
    
    @IBAction func showWithImages(sender: UIButton) {
        pickerWithImage = CZPickerView(headerTitle: "Specialities", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        pickerWithImage?.delegate = self
        pickerWithImage?.headerBackgroundColor = appGold
        pickerWithImage?.dataSource = self
        pickerWithImage?.needFooterView = false
        pickerWithImage?.show()
    }

    
    func validationSuccessful() {
        print("success")
        
        RequestManager.defaultManager.updateProfileForUser(phoneNumber: mobileTextfield.text!, firstName: firstNameTextfield.text!, secondName: secondNameTextfield.text!, email: emailTextfield.text!, speciality: selectedSpecialityID) { (error, recError) in
            print(error)
            if !error{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "\((recError?.code!)!)", message: (recError?.desc!)!, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.backTapped(self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (_, error) in errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
        self.showAlertWithTitle(title: "Failed", message: "please fill all the mandatory fields")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextfield:
            firstNameErrorLabel.isHidden = true
        case secondNameTextfield:
            secondNameErrorLabel.isHidden = true
        case mobileTextfield:
            mobileErrorLabel.isHidden = true
        default:
            specialityErrorLabel.isHidden = true
        }
        validator.validateField(textField) { (error) in
            if error != nil {
                error?.errorLabel?.text = error?.errorMessage
                error?.errorLabel?.isHidden = false
            }
        }
    }
    
    @IBAction func updateTapped(){
        self.validator.validate(self)
    }
    
    @IBAction func chooseImageTapped(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
//        imagePicker.navigationBar.backgroundColor = self.navigationBarView.backgroundColor
        present(imagePicker, animated: true, completion: nil)
    }
    
}


extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.userImageView.image = pickedImage
            let smallImage = resizeImage(image: pickedImage, newWidth: 100)
            if let jpegData = smallImage.jpeg {
                
                let encodedImage = jpegData.base64EncodedString(options: .lineLength64Characters)
                
                RequestManager.defaultManager.setImageForUser(image: encodedImage) { (error, recError) in
                    print("Test",error)
                    if !error{
                        
                    }
                }
                
            
            }else{
                self.dismiss(animated: true, completion: {
                    self.showAlertWithTitle(title: "Failed", message: "Sorry,unsupported this image format")
                })
            }
        }else{
            self.dismiss(animated: true, completion: {
                self.showAlertWithTitle(title: "Failed", message: "Sorry,unsupported this image format")
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension EditProfileVC: CZPickerViewDelegate, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return specialities.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        if pickerView == pickerWithImage {
            let url = URL(string: SP_ImageUrl + (specialities[row].image)!)!
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

}
