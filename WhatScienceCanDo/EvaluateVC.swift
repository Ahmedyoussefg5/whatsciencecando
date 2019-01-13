//
//  EvaluateVC.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/6/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit

class EvaluateVC: BaseViewController ,UITextFieldDelegate{
    
    @IBOutlet var ratingBtns :[UIButton]!
    @IBOutlet weak var commentTextfield: UITextField!
    let blackView = UIView()
    let picker = UIPickerView()
    var toolBar = UIToolbar()
    var row = 0
    var index = 0
    var eventID:Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextfield.delegate = self
        self.configurePickerToolbar()
        self.pickerConfiguration()
        
    }
    
    override func getData() {
        super.getData()

        RequestManager.defaultManager.getEvaluationForEventWithID(ID: eventID) { (error, overall, content, venue, comment,is_evaluated, recError) in
            print(error)
            if !error{
                DispatchQueue.main.async {
                    if is_evaluated! {
                        self.title = "Update Evaluation"
                    }else{
                        self.title = "Evaluate"
                    }
                    
                    self.ratingBtns[0].setTitle("\(overall)", for: .normal)
                    self.ratingBtns[1].setTitle("\(content)", for: .normal)
                    self.ratingBtns[2].setTitle("\(venue)", for: .normal)
                    self.commentTextfield.text = comment!
                    self.activityIndicator.stopAnimating()
                }
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func rateTapped(_ sender: UIButton){
        print(sender.tag)
        showPicker(ForTag: sender.tag)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        RequestManager.defaultManager.submitEvaluationForSessionWithID(ID: eventID, overall: (ratingBtns[0].titleLabel?.text!)!, content: (ratingBtns[1].titleLabel?.text!)!, venue: (ratingBtns[2].titleLabel?.text!)!, comment: commentTextfield.text!) { (error, recError) in
            print(error)
            if !error{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "\((recError?.code!)!)", message: (recError?.desc!)!, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.backTapped(self)
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
    
    func configurePickerToolbar()  {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = appBrown
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = ""
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([okBarBtn,flexSpace,textBtn], animated: true)
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func pickerConfiguration() {
        picker.delegate   = self
        picker.dataSource = self
        
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "  Done", style: .done, target: self, action: #selector(selectFromPicker))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
    }
    
    @IBAction func selectFromPicker() {
        row = picker.selectedRow(inComponent: 0)
        print(row)
        ratingBtns[picker.tag].setTitle("\(row + 1)", for: .normal)

        dismissBlackView()
    }
    
    func showPicker(ForTag tag:Int){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBlackView)))
            //
            window.addSubview(blackView)
            window.addSubview(picker)
            window.addSubview(toolBar)
            
            let y = window.frame.height - 200
            
            picker.frame = CGRect(x: 0, y: self.view.frame.height + toolBar.frame.height, width: self.view.frame.width, height: 200)
            toolBar.frame.origin.y = picker.frame.origin.y - toolBar.frame.height
            picker.tag = tag
            picker.reloadAllComponents()
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.picker
                    .frame = CGRect(x: 0,y: y,width: self.view.frame.width,height: self.picker.frame.height )
                self.toolBar.frame.origin.y = self.picker.frame.origin.y - self.toolBar.frame.height
            }, completion: nil)
        }
    }
    
    @IBAction func dismissBlackView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.picker.frame = CGRect(x: 0,y: self.blackView.frame.height,width: self.blackView.frame.width,height: 200)
            self.toolBar.frame.origin.y = self.picker.frame.origin.y - self.toolBar.frame.height
            self.blackView.alpha = 0
            self.picker.removeFromSuperview()
            self.toolBar.removeFromSuperview()
        },completion: nil)
    }


}

extension EvaluateVC : UIPickerViewDataSource, UIPickerViewDelegate{
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(row + 1)"
    }
    
}

