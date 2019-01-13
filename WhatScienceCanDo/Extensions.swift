//
//  Extensions.swift
//  Modazee
//
//  Created by Ahmed_OS on 5/8/17.
//  Copyright © 2017 Ahmed_OS. All rights reserved.
//

import UIKit
//let ServerUrl = "http://wscdchat.scope-rubix.com"
//let URL_IMAGE_PREFIX = "http://wscd2.scope-rubix.com/"

let ServerUrl = "http://Wscd3.scope-rubix.com/"
let ChatUrl = "http://Wscd3.scope-rubix.com"
let URL_IMAGE_PREFIX = "http://Wscd3.scope-rubix.com/assets/images/newsletters/"
let URL_Video_PREFIX = "http://Wscd3.scope-rubix.com/assets/videos/newsletters/"
let SERVICE_URL_PREFIX = "http://Wscd3.scope-rubix.com/api/"
var ACCESS_TOKEN = ""
let EncylopediaUrl = ServerUrl +  "assets/files/encyclopedias/"
let NewsLetterPdfLink = ServerUrl + "assets/files/newsletters/"
let SP_ImageUrl = "http://Wscd3.scope-rubix.com"

var CURRENT_USER:User? {
    didSet{
        debugPrint("Set")
    }
}

var showEventsCalendar = true

var appBrown = UIColor.init(red: 84/255, green: 40/255, blue: 13/255, alpha: 1)
var appGold = UIColor.init(red: 255/255, green: 193/255, blue: 7/255, alpha: 1)
var appRed = UIColor.init(red: 133/255, green: 0/255, blue: 78/255, alpha: 1)
var appGray = UIColor.init(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)

enum Gender:Int{
    case Male = 0
    case Female = 1
}

enum OrderType:Int{
    case Delivery = 0
    case Takeaway = 1
    case Checkin = 2
}

enum UserCategory {
    case jobSeeker
    case Company
}
let userData  = UserDefaults.standard

extension NSMutableURLRequest{
    func setBodyConfigrationWithMethod(method:String){
        self.httpMethod = method
        self.setValue("application/json",forHTTPHeaderField:"Accept")
//        self.setValue("application/json",forHTTPHeaderField:"Content-Type")
//        self.setValue("utf-8", forHTTPHeaderField: "charset")
        self.addValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        debugPrint(ACCESS_TOKEN)
    }
}

extension UITableView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.tableFooterView = UIView()
    }
}


extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 0.5)
    }
    var png: Data? {
        return UIImagePNGRepresentation(self)
    }
}

extension UIView{
    
    func dropShadow(scale: Bool = true) {
        DispatchQueue.main.async {
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shadowRadius = 1
            
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    }

    func performConstraintsWithFormat(format:String,views:UIView...) {
        
        var viewsDic = [String:UIView]()
        
        for (index,view) in views.enumerated(){
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDic["v\(index)"] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDic))
        
    }
    
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}


func randomNumber(range: ClosedRange<Int> = 1...6) -> Int {
    let min = range.lowerBound
    let max = range.upperBound
    return Int(arc4random_uniform(UInt32(1 + max - min))) + min
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func reload(){
        self.viewDidLoad()
    }
    
    @IBAction func backTapped(_ sender: Any?) {
        if let _  = self.navigationController?.popViewController(animated: true){
            
        }
    }
}

enum VendingMachineError:Error {
    case valueNotFounds
}

extension Date{
    func getStringFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self as Date)
    }
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension NSDictionary {
    func getValueForKey<T>(key:String,callback:T)  -> T{
        guard let value  = self[key] as? T else{
            return callback}
        return value
    }
    func getValueForKey<T>(key:String) throws -> T{
        guard let value  = self[key] as? T else{throw VendingMachineError.valueNotFounds}
        return value
    }
}

extension UIViewController{
    func showAlertWithTitle(title:String,message:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showFailedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Failed", message: "Couldn't Get Your Data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.view.isUserInteractionEnabled = false
                self.backTapped(nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showNoData(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sorry", message: "There's no data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

enum AppErrorCode:Int {
    case Success = 0
    case MobileAlreadyExists = 1
    case EmailAlreadyExists = 2
    case DatabaseConnectionError = 3
    case AccounIsNotActive = 4
    case WrongCobinationOfPasswordOrUsername = 5
    case YouMustDetermineAccountType = 6
    case UserDoesnotExist = 7
    case CodeDoesnotMatch = 8
    case unauthorized = 9
    case errorSendingSms = 10
    case requestAlreadyExists = 11
    case requestDoesnotExist = 12
    case ValidationError = 400
    case NotFound = 204
    case Down = 404    
}

public enum AppLanguage:String {
    case arabic = "ar"
    case english = "en"
}
