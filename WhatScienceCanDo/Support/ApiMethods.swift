//
//  ApiMethods.swift
//  WhatScienceCanDo
//
//  Created by MOHAMED on 9/4/18.
//  Copyright © 2018 RKAnjel. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class ApiMethods {
  // Get NewsLetter List
    class func GetNewsLetter(api_token : String,compltion : @escaping (_ status: Bool?,_ api_token_status : Bool? ,_ news : [String : JSON]?, _ error: Error? )->Void) {
            let parameters = [
                "api_token" : api_token
            ]
            
            
        let url = URL(string: NewsLetterUrl)
        //192.168.0.14
            Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (response) in
                
                switch response.result {
                case .failure(let error) :
                    let json = JSON(error)
                    print("error" , error)
                 compltion(false, false, nil , error)
                    return
                case .success(let value) :
                    let json = JSON(value)
                    var News = [String : JSON]()
                  
                    let status = json["status"].bool

                    let api_token_status = json["status_token"].bool
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM"

                    if var newsletter = json["newsletters"].dictionary{
                        let sortedArrayOfDicts = newsletter
                            //First map to an array tuples: [(Date, [String:Int]]
                            .map{(df.date(from: $0.key)!, [$0.key:$0.value])}
                            
                            //Now sort by the dates, using `<` since dates are Comparable.
                            .sorted{$0.0 < $1.0}
                            
                            //And re-map to discard the Date objects
                            .map{$1}
                        
                        print("Success JSon NewsLetter ", sortedArrayOfDicts[0])
                        for new in 0...sortedArrayOfDicts.count - 1{
                             let key = sortedArrayOfDicts[new].first?.key
                            let value = sortedArrayOfDicts[new].first?.value
                            News.updateValue(value!, forKey: key!)
                            
                           // News[key!] = value
                            print("obj" , key)
                            
                        }
                    
                        let sortedArray = News
                            //First map to an array tuples: [(Date, [String:Int]]
                            .map{(df.date(from: $0.key)!, [$0.key:$0.value])}
                            
                            //Now sort by the dates, using `<` since dates are Comparable.
                            .sorted{$0.0 < $1.0}
                            
                            //And re-map to discard the Date objects
                            .map{$1}
                       // print("Element" , News)

                        /*
                        for i in newsletter {
                            if let obj = i.dictionary {
                                News.append(obj)
                            }
                        }
                        
                        */
                        }
 
                    compltion(status, api_token_status, News, nil)

                    return
                    
                }
            }
        }
    
    // Get Doctors List
    class func GetDoctorsList(api_token : String , page : Int = 1, compltion : @escaping (_ status: Bool?, _ error: Error? , _ api_token_status: Bool? , _ doctots : [AskTheExpertModel]?  , _ last_page : Int? )->Void) {
        let parameters = [
            "api_token" : api_token,
            "page" : page
            ] as [String : Any]
        let url = URL(string: GetDoctorsUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("Error" , error)
                compltion(false , error , nil  ,nil, nil)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Json" , json)
                let status = json["status"].bool
                let api_token_status = json["status_token"].bool
                var doctors = [AskTheExpertModel]()
                if let result = json["doctors"].dictionary {
                    let last_page = result["last_page"]?.int
                    if let AllTests = result["data"]?.array {
                        for obj in AllTests {
                            if let obj = obj.dictionary {
                                let doctor = AskTheExpertModel(Single: obj)
                                doctors.append(doctor)
                            }
                            
                        }
                        compltion(status, nil, api_token_status,doctors, last_page)
                        return
                        break
                    }
                }
                
                
            }
        }
    }
    
    // Send Question To Doctor
    class func SendQuestionToDoctor(api_token : String,doctor_id : Int , subject : String , email : String , message : String, compltion : @escaping (_ status: Bool?,_ api_token_status : Bool? ,_  message : String?,_ error: Error?)->Void) {
        let parameters = [
            "api_token" : api_token ,
            "doctor_id" : doctor_id ,
            "subject" : subject ,
            "email" : email ,
            "message" : message
            ] as [String : Any]
        
        
        let url = URL(string: SendQuestionToDoctorUrl)
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("error" , error)
                compltion(false, false, nil, error)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Success JSon", json)
                let status = json["status"].bool
                
                let api_token_status = json["status_token"].bool
                let message = json["message"].string
                compltion(status, api_token_status, message, nil)
                return
                
            }
        }
    }
    
    // Get My Chat Groups List
    class func GetMyGroupsList(api_token : String , page : Int = 1, compltion : @escaping (_ status: Bool?, _ error: Error? , _ api_token_status: Bool? , _ groups : [MyGroupsModel]?  , _ last_page : Int? )->Void) {
        let parameters = [
            "api_token" : api_token,
            "page" : page
            ] as [String : Any]
        let url = URL(string: GetMyChatGroupsUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("Error" , error)
                compltion(false , error , nil  ,nil, nil)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Json" , json)
                let status = json["status"].bool
                let api_token_status = json["status_token"].bool
                var groups = [MyGroupsModel]()
                if let result = json["my_groups"].dictionary {
                    let last_page = result["last_page"]?.int
                    if let AllTests = result["data"]?.array {
                        for obj in AllTests {
                            if let obj = obj.dictionary {
                                let group = MyGroupsModel(Single: obj)
                                groups.append(group)
                            }
                            
                        }
                        compltion(status, nil, api_token_status,groups, last_page)
                        return
                        break
                    }
                }
                
                
            }
        }
    }
    
    // Get All Chat Groups List
    class func GetAllChatGroups(api_token : String , page : Int = 1, compltion : @escaping (_ status: Bool?, _ error: Error? , _ api_token_status: Bool? , _ groups : [AllGroupsModel]?  , _ last_page : Int? )->Void) {
        let parameters = [
            "api_token" : api_token,
            "page" : page
            ] as [String : Any]
        let url = URL(string: GetAllChatGroupsUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("Error" , error)
                compltion(false , error , nil  ,nil, nil)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Json" , json)
                let status = json["status"].bool
                let api_token_status = json["status_token"].bool
                var groups = [AllGroupsModel]()
                if let result = json["available_groups"].dictionary {
                    let last_page = result["last_page"]?.int
                    if let AllTests = result["data"]?.array {
                        for obj in AllTests {
                            if let obj = obj.dictionary {
                                let group = AllGroupsModel(Single: obj)
                                groups.append(group)
                            }
                            
                        }
                        compltion(status, nil, api_token_status,groups, last_page)
                        return
                        break
                    }
                }
                
                
            }
        }
    }
    
    // Ask To Join Chat Group
    class func AskToGoinChatGroup(api_token : String,group_id : Int , compltion : @escaping (_ status: Bool?,_ api_token_status : Bool? ,_  message : String?,_ error: Error?)->Void) {
        let parameters = [
            "api_token" : api_token ,
            "group_id" : group_id ,
          
            ] as [String : Any]
        
        
        let url = URL(string: JoinGroupUrl)
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("error" , error)
                compltion(false, false, nil, error)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Success JSon", json)
                let status = json["status"].bool
                
                let api_token_status = json["status_token"].bool
                let message = json["message"].string
                compltion(status, api_token_status, message, nil)
                return
                
            }
        }
    }
    
    // Get Encyclopedia
    //GetEncyclopediaUrl
    class func GetEncyclopediaArticles(api_token : String ,sectionId : Int, page : Int = 1, compltion : @escaping (_ status: Bool?, _ error: Error? , _ api_token_status: Bool? , _ articles : [EncyclopediaModel]?  , _ last_page : Int? )->Void) {
        let parameters = [
            "api_token" : api_token,
            "section" : sectionId,
            "page" : page
            ] as [String : Any]
        let url = URL(string: GetEncyclopediaUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("Error" , error)
                compltion(false , error , nil  ,nil, nil)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Json" , json)
                let status = json["status"].bool
                let api_token_status = json["status_token"].bool
                var articles = [EncyclopediaModel]()
                if let result = json["encyclopedias"].dictionary {
                    let last_page = result["last_page"]?.int
                    if let AllArticles = result["data"]?.array {
                        for obj in AllArticles {
                            if let obj = obj.dictionary {
                                let article = EncyclopediaModel(Single: obj)
                                articles.append(article)
                            }
                            
                        }
                        compltion(status, nil, api_token_status,articles, last_page)
                        return
                        break
                    }
                }
                
                
            }
        }
    }
    
    // Get Encyclopedia Main Department
    class func GetEncyclopediaMainDep(api_token : String , page : Int = 1, compltion : @escaping (_ status: Bool?, _ error: Error? , _ api_token_status: Bool? , _ articles : [EncyclopediaDepModel]?  , _ last_page : Int? )->Void) {
        let parameters = [
            "api_token" : api_token,
            "page" : page
            ] as [String : Any]
        let url = URL(string: GetEncyclopediaMainDepUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("Error" , error)
                compltion(false , error , nil  ,nil, nil)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Json Sections :-" , json)
                let status = json["status"].bool
                let api_token_status = json["status_token"].bool
                var articles = [EncyclopediaDepModel]()
                if let result = json["sections"].dictionary {
                    let last_page = result["last_page"]?.int
                    if let AllArticles = result["data"]?.array {
                        for obj in AllArticles {
                            if let obj = obj.dictionary {
                                let article = EncyclopediaDepModel(Single: obj)
                                articles.append(article)
                            }
                            
                        }
                        compltion(status, nil, api_token_status,articles, last_page)
                        return
                        break
                    }
                }
                
                
            }
        }
    }
    
    // Get Counter Notification
    class func GetNotificationCounter(api_token : String , compltion : @escaping (_ status: Bool?,_ api_token_status : Bool? ,_  eventCounter : Int? , _ newsLetterCounter : Int? , _ chatCounter : Int?,_ error: Error?)->Void) {
        let parameters = [
            "api_token" : api_token ,
            
            ] as [String : Any]
        
        
        let url = URL(string: GetNotificationCounterUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("error" , error)
                compltion(false, false, nil, nil , nil,error)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Success JSon", json)
                let status = json["status"].bool
                
                let api_token_status = json["status_token"].bool
                let NewsLetterCounter = json["countNewsletters"].int
                let EventCounter = json["countEvents"].int
                let chatCounter = json["countChat"].int
                compltion(status, api_token_status, EventCounter ,NewsLetterCounter ,  chatCounter, nil)
                return
                
            }
        }
    }
    // Update Notifications
    class func UpdateNotification(api_token : String ,notification_Type : String, compltion : @escaping (_ status: Bool?,_ api_token_status : Bool? ,_ error: Error?)->Void) {
        let parameters = [
            "api_token" : api_token ,
            notification_Type  : "1"
            ] as [String : Any]
        
        
        let url = URL(string: UpdateSeenNotificationUrl)
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("error" , error)
                compltion(false, false, error)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Notification JSon", json)
                let status = json["status"].bool
                let api_token_status = json["status_token"].bool
                compltion(status, api_token_status, nil)
                return
                
            }
        }
    }
    // Get Notifications
    class func GetNotifications(api_token : String , page : Int = 1, compltion : @escaping (_ status: Bool?, _ error: Error? , _ tests : [NotificationModel]?  , _ last_page : Int? )->Void) {
        let parameters = [
            "api_token" : api_token,
            "page" : page
            ] as [String : Any]
        let url = URL(string: GetAllNotificationUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("Error" , error)
                compltion(false , error , nil  , nil)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Json" , json)
                let status = json["status"].bool
                var tests = [NotificationModel]()
                if let result = json["notifications"].dictionary {
                    let last_page = result["last_page"]?.int
                    if let AllTests = result["data"]?.array {
                        for obj in AllTests {
                            if let obj = obj.dictionary {
                                let test = NotificationModel(Single: obj)
                                tests.append(test)
                            }
                            
                        }
                        compltion(status, nil, tests, last_page)
                        return
                        break
                    }
                }
                
                
            }
        }
    }
    // Get Notifications
    class func GetDataForSingleNotification(api_token : String ,type_id : Int,  notifyType : String, compltion : @escaping (_ status: Bool?, _ error: Error? , _ data : [String:JSON]?  )->Void) {
        // var groupId : Int!
       // var ChatName : String!
        let parameters = [
            "api_token" : api_token,
            "type_id" : type_id ,
            "type" : notifyType
            ] as [String : Any]
        let url = URL(string: GetSingleNotifyDetailsUrl)
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("Error" , error)
                compltion(false, error, nil)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Json" , json)
                let status = json["status"].bool
                var tests  = [String:JSON]()
              
                    if let AllTests = json["data"].dictionary {
                        
                       compltion(status, nil, AllTests)
                        return
                        break
                    }
                
            }
        }
    }
    // Reset Password
    class func ResetPassword(email : String ,compltion : @escaping (_ status: Bool?,_ message:String? , _ error: Error?)->Void) {
        let parameters = [
            "email" : email
        ]
        let url = URL(string: ResetPasswordUrl)
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                
                print("error" , error)
                compltion(false, nil , error)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Login JSon" , json)
                let status = json["status"].bool
                
                
                compltion(status, nil, nil)
                return
                
            }
        }
    }
}
