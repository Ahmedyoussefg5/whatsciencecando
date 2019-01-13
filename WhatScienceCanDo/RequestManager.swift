//
//  RequestManager.swift
//  Modazee
//
//  Created by Ahmed_OS on 5/10/17.
//  Copyright © 2017 Ahmed_OS. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
class RequestManager{
    let timoutRequest = 20.0
    static let defaultManager = RequestManager()
    private init (){}
    /*
     
     let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "login_user")! ,
     cachePolicy: .useProtocolCachePolicy,
     timeoutInterval: timoutRequest)
     mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
     
     let postmsg = "email=\(email)&password=\(password)&"
     mutableURLRequest.httpBody = postmsg.data(using: .utf8)
     let session = URLSession.shared
     let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
     if let res:HTTPURLResponse = response as? HTTPURLResponse {
     if (error != nil || res.statusCode != 200) {
     compilition(true, nil)
     return
     } else {
     var json: NSDictionary!
     do {
     json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
     print(json)
     } catch {
     compilition(true, nil)
     }
     if let response = json["Error"] as? NSDictionary {
     let error = AppError(data: response)
     print("Error" , error)
     if error.code == .Success {
     if let response = json["Response"] as? NSDictionary {
     print("Response" , response)
     CURRENT_USER = User(data:response)
     userData.set(CURRENT_USER?.id!, forKey: "ID")
     userData.set((CURRENT_USER?.first_name!)!, forKey: "first_name")
     userData.set((CURRENT_USER?.last_name!)!, forKey: "last_name")
     userData.set((CURRENT_USER?.mobile!)!, forKey: "mobile")
     userData.set((CURRENT_USER?.image!)!, forKey: "image")
     userData.set((CURRENT_USER?.email!)!, forKey: "email")
     
     RequestManager.defaultManager.sendDeviceToken(compilition: { (error, recError) in
     print( "Notification Error" , error)
     })
     
     
     }
     
     }
     compilition(false,error)
     }else{
     compilition(true, nil)
     }
     
     }
     }else {
     compilition(true, nil)
     }
     
     })
     dataTask.resume()
     */
    // Sign in  ---->
    func loginWithemail(email:String,password:String,compilition : @escaping (_ status : Bool?,_ resError:Error?)->Void){
        let parameters = [
            "email" : email ,
            "password" : password
        ]
        let url = URL(string: SERVICE_URL_PREFIX + "login_user")
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .failure(let error) :
                let json = JSON(error)
                print("JSon" , json)
                print("Error" , error)
                compilition(false , error)
                return
            case .success(let value) :
                let json = JSON(value)
                print("Login JSon" , json)
                let status = json["status"].bool
             
                if let result = json["user"].dictionary {
                    let resultNsDictionary = NSMutableDictionary(dictionary: result)
                    CURRENT_USER = User(data:resultNsDictionary)

                    if let api_token = json["api_token"].string {
                        ApiToken.SetItems(Key: "api_token", Value: api_token)
                        CURRENT_USER?.api_token = api_token

                    }
                    if let id = result["id"]?.int {
                        ApiToken.SetItems(Key: "user_id", Value: String(describing: id))
                        CURRENT_USER?.id = id
                        print("Current User Id" , CURRENT_USER?.id)
                    }
                    if let vip = result["vip"]?.int {
                        ApiToken.SetItems(Key: "vip", Value: String(vip))
                    }
                    if let first_name = result["first_name"]?.string {
                        ApiToken.SetItems(Key: "user_first_name", Value: first_name)
                        CURRENT_USER?.first_name = first_name
                        print("Current Name" ,  CURRENT_USER?.first_name )
                  
                    }
                    if let last_name = result["last_name"]?.string {
                        ApiToken.SetItems(Key: "user_last_name", Value: last_name)
                        CURRENT_USER?.last_name = last_name
                        
                    }
                    if let mobile = result["mobile"]?.string {
                        ApiToken.SetItems(Key: "user_mobile", Value: mobile)
                        CURRENT_USER?.mobile = mobile
                        
                    }
                    if let image = result["image"]?.string {
                        ApiToken.SetItems(Key: "user_image", Value: image)
                        CURRENT_USER?.image = image
                        
                    }
                    if let email = result["email"]?.string {
                        ApiToken.SetItems(Key: "user_email", Value: email)
                        CURRENT_USER?.email = email
                    }
                    if let spaciality_id = result["speciality_id"]?.int {
                        ApiToken.SetItems(Key: "speciality_id", Value: String(spaciality_id))
                    }
                    if let spaciality_name = result["user_specialtiy"]?.string {
                        ApiToken.SetItems(Key: "user_specialtiy", Value: spaciality_name)
                    }
                    if let is_active = result["is_active"]?.bool {
                        ApiToken.SetItems(Key: "is_active", Value: String(is_active))
                        CURRENT_USER?.is_active = is_active
                    }

                   
                
                  
                }
                
                
                compilition(status, nil)
                return
                
            }
        }
    }
    
    // Signup  ---->
    func signupWithEmail(email:String,activation : String,password:String,phoneNumber:String,firstName:String,lastName:String,specialityID:Int,compilition : @escaping (_ error : Bool,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "register")!,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        let postmsg = "email=\(email)&password=\(password)&mobile=\(phoneNumber)&first_name=\(firstName)&last_name=\(lastName)&speciality_id=\(specialityID)&code=\(activation)"
        print(postmsg)
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                print(res.statusCode)
                if (error != nil || res.statusCode != 200) {
                    compilition(true,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true,nil)
                    }
                    
                    var error:AppError!
                    
                    if let response = json["Error"] as? NSDictionary {
                        error = AppError(data: response)
                        if error.code == .Success {
                            if let response = json["Response"] as? NSDictionary {
                            
                                
                                RequestManager.defaultManager.sendDeviceToken(compilition: { (error, recError) in
                                    print(error)
                                })
                                
                                
                            }
                        }
                        compilition(false,error)
                    }else{
                        compilition(true,nil)
                        return
                    }
                }
            }else {
                compilition(true,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // Update Profile ---->
    func updateProfileForUser(phoneNumber:String,firstName:String,secondName:String,email:String,speciality:Int,compilition : @escaping (_ error : Bool,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "update-profile")!,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        guard let id = CURRENT_USER?.id else {
            return
        }
        
        let postmsg = "user_id=\(id)&mobile=\(phoneNumber)&first_name=\(firstName)&last_name=\(secondName)&email=\(email)&speciality_id=\(speciality)"
        print(postmsg)
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                print(res.statusCode)
                if (error != nil || res.statusCode != 200) {
                    compilition(true,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true,nil)
                    }
                    
                    var error:AppError!
                    
                    if let response = json["Error"] as? NSDictionary {
                        error = AppError(data: response)
                        
                        if let response = json["Response"] as? NSDictionary {
                            if error.code == .Success {
                                CURRENT_USER = User(data: response)
                                userData.set((CURRENT_USER?.first_name!)!, forKey: "user_first_name")
                                userData.set((CURRENT_USER?.last_name!)!, forKey: "user_last_name")
                                userData.set((CURRENT_USER?.mobile!)!, forKey: "user_mobile")
                                userData.set((CURRENT_USER?.image!)!, forKey: "user_image")
                                userData.set((CURRENT_USER?.email!)!, forKey: "user_email")
                                
                            }
                        }
                        compilition(false,error)
                    }else{
                        compilition(true,nil)
                        return
                    }
                }
            }else {
                compilition(true,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // Send Device Token
    
    func AddOneSignalToken(token : String!) {
        print("Token :-" , token)
        guard let id = CURRENT_USER?.id else {return}
        let parameters = [
            
            "user_id" : id ,
            "token" :  token,
            
            ] as [String : Any]
        let url = URL(string: SERVICE_URL_PREFIX + "notifications/token_update")!
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let myerror) :
                print(myerror)
                let error = JSON(myerror)
                print(error)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
            }
        }
    }
    func sendDeviceToken(compilition : @escaping (_ error : Bool,_ resError:AppError?)->Void) {
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "notifications/token_update")!,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: 10.0)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        let firbaseToken = ApiToken.GetItem(Key: "OneSignalToken")
        
        guard let id = CURRENT_USER?.id else{
            return
        }
       let token = firbaseToken
        let postmsg = "user_id=\(id)&token=\(token)"
        print("Notification Test :" ,postmsg)
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    compilition(true,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    } catch {
                        compilition(true,nil)
                    }
                    
                    var error:AppError!
                    print("Json Test Notify" , json)
                    if json != nil {
                    if let response = json["Error"] as? NSDictionary {
                        error = AppError(data: response)
                        compilition(false,error!)
                    }
                }
                }
            }else {
                compilition(true,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // Forget Password  ---->
    func sendPasswordForUserWithEmail(email:String,compilition : @escaping (_ error : Bool,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: NSURL(string: SERVICE_URL_PREFIX + "/api/forgot-password")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: 10.0)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        let postmsg = "email=\(email)"
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    compilition(true,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    } catch {
                        compilition(true,nil)
                    }
                    
                    var error:AppError!
                    if let response = json["Error"] as? NSDictionary {
                        error = AppError(data: response)
                        compilition(false,error!)
                    }
                }
            }else {
                compilition(true,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // get Specialities  ---->
    func getSpecialities(compilition : @escaping (_ error : Bool,_ results:[BaseModel]?,_ resError:AppError?)->Void){
        
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "lists")! ,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    compilition(true, nil,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true, nil,nil)
                    }
                    var searchResult : [BaseModel] = []
                    
                    if let mainResponse = json["Response"] as? NSDictionary {
                        if let response = mainResponse["specialities"] as? NSArray {
                            for res in response{
                                searchResult.append(BaseModel(data: res as AnyObject))
                            }
                        }
                    }
                    
                    if let response = json["Error"] as? NSDictionary {
                        let error = AppError(data: response)
                        compilition(false,searchResult,error)
                    }else{
                        compilition(true, nil,nil)
                    }
                    
                }
            }else {
                compilition(true, nil,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // get Events  ---->
    func getEventsWith(date:String,forEvents:Bool,compilition : @escaping (_ error : Bool,_ results:[Event]?,_ resError:AppError?)->Void){
        var suffix = "events"
        if !forEvents {
            suffix = "newsletter"
        }
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + suffix)! ,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        guard let id = CURRENT_USER?.id else {
            return
        }
        print("Date" , date)
        let postmsg = "user_id=\(id)&date=\(date)"
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    compilition(true, nil,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true, nil,nil)
                    }
                    var searchResult : [Event] = []
                    if json != nil {
                        print("JSOn" , json)
                    if let response = json["Response"] as? [NSDictionary] {
                        for res in response{
                            print("Res" , res)
                            searchResult.append(Event(data: res as AnyObject))
                        }
                    }
                  
                    if let response = json["Error"] as? NSDictionary {
                        let error = AppError(data: response)
                        compilition(false,searchResult,error)
                    }else{
                        compilition(true, nil,nil)
                    }
                     }
                }
                
            }else {
                compilition(true, nil,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // get Sessions  ---->
    func getSessionsForEventWithID(ID:Int,compilition : @escaping (_ error : Bool,_ results:[Session]?,_ resError:AppError?)->Void){
        
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "events/sessions")! ,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        let postmsg = "event_id=\(ID)"
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    compilition(true, nil,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true, nil,nil)
                    }
                    var searchResult : [Session] = []
                    
                    if let response = json["Response"] as? [NSDictionary] {
                        for res in response{
                            searchResult.append(Session(data: res as AnyObject))
                        }
                    }
                    
                    if let response = json["Error"] as? NSDictionary {
                        let error = AppError(data: response)
                        compilition(false,searchResult,error)
                    }else{
                        compilition(true, nil,nil)
                    }
                    
                }
            }else {
                compilition(true, nil,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // Get Evaluation  ---->
    func getEvaluationForEventWithID(ID:Int,compilition : @escaping (_ error : Bool,_ overall:Int,_ content:Int,_ venue:Int,_ comment:String?,_ is_evaluated:Bool?,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "is-evaluate")! ,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        guard let id = CURRENT_USER?.id else {
            return
        }
        let postmsg = "user_id=\(id)&event_id=\(ID)"
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    compilition(true, 0, 0, 0, "",false, nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true, 0, 0, 0, "",false, nil)
                    }
                    
                    var overall:Int?
                    var content:Int?
                    var venue:Int?
                    var comment:String?
                    var is_evaluated:Bool?
                    
                    if let response = json["Response"] as? NSDictionary {
                        overall = response.getValueForKey(key: "overall", callback: 1)
                        content = response.getValueForKey(key: "content", callback: 1)
                        venue = response.getValueForKey(key: "venue", callback: 1)
                        is_evaluated = response.getValueForKey(key: "is_evaluate", callback: 0) == 1
                        
                        comment = response.getValueForKey(key: "comment", callback: "")
                    }else{
                        compilition(true, 0, 0, 0, "",false, nil)
                    }
                    if let response = json["Error"] as? NSDictionary {
                        let error = AppError(data: response)
                        compilition(false,overall!,content!,venue!,comment!,is_evaluated!,error)
                    }else{
                        compilition(true, 0, 0, 0, "",false, nil)
                    }
                    
                }
            }else {
                compilition(true, 0, 0, 0, "",false, nil)
            }
            
        })
        dataTask.resume()
    }
    
    // Get Profile  ---->
    func getUserProfile(compilition : @escaping (_ error : Bool,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "profile")! ,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        guard let id = CURRENT_USER?.id else {
            return
        }
        
        let postmsg = "user_id=\(id)"
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                if (error != nil || res.statusCode != 200) {
                    compilition(true, nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(json)
                    } catch {
                        compilition(true, nil)
                    }
                    
                    if let response = json["Response"] as? NSDictionary {
                        
                        CURRENT_USER = User(data:response)
                        userData.set(CURRENT_USER?.id!, forKey: "ID")
                        userData.set((CURRENT_USER?.first_name!)!, forKey: "first_name")
                        userData.set((CURRENT_USER?.last_name!)!, forKey: "last_name")
                        userData.set((CURRENT_USER?.mobile!)!, forKey: "mobile")
                        userData.set((CURRENT_USER?.image!)!, forKey: "image")
                        userData.set((CURRENT_USER?.email!)!, forKey: "email")
                        
                    }else{
                        compilition(true, nil)
                    }
                    if let response = json["Error"] as? NSDictionary {
                        let error = AppError(data: response)
                        compilition(false,error)
                    }else{
                        compilition(true, nil)
                    }
                    
                }
            }else {
                compilition(true, nil)
            }
            
        })
        dataTask.resume()
    }
    
    // Set Image For User ---->
    func setImageForUser(image:String,compilition : @escaping (_ error : Bool,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "update-image")! ,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        
        guard let id = CURRENT_USER?.id else {
            return
        }
        let postmsg = "user_id=\(id)&image=\(image)"
        print(postmsg)
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                print("Res" , res)
                userData.set(CURRENT_USER?.id!, forKey: "ID")
                userData.set((CURRENT_USER?.first_name!)!, forKey: "first_name")
                userData.set((CURRENT_USER?.last_name!)!, forKey: "last_name")
                userData.set((CURRENT_USER?.mobile!)!, forKey: "mobile")
                userData.set((CURRENT_USER?.image!)!, forKey: "image")
                userData.set((CURRENT_USER?.email!)!, forKey: "email")
                print(res.statusCode)
                if (error != nil || res.statusCode != 200) {
                    compilition(true,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    } catch {
                        compilition(true,nil)
                    }
                    
                    var error:AppError!
                    if let response = json["Error"] as? NSDictionary {
                        error = AppError(data: response)
                        compilition(false,error!)
                    }
                }
            }else {
                compilition(true,nil)
            }
            
        })
        dataTask.resume()
    }
    
    // Submit Evaluation ---->
    func submitEvaluationForSessionWithID(ID:Int,overall:String,content:String,venue:String,comment:String,compilition : @escaping (_ error : Bool,_ resError:AppError?)->Void){
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: SERVICE_URL_PREFIX + "evaluate")! ,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: timoutRequest)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "POST")
        guard let id = CURRENT_USER?.id else {
            return
        }
        let postmsg = "user_id=\(id)&overall=\(overall)&content=\(content)&venue=\(venue)&comment=\(comment)&event_id=\(ID)"
        print(postmsg)
        mutableURLRequest.httpBody = postmsg.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                print(res.statusCode)
                if (error != nil || res.statusCode != 200) {
                    compilition(true,nil)
                    return
                } else {
                    var json: NSDictionary!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    } catch {
                        compilition(true,nil)
                    }
                    
                    var error:AppError!
                    if let response = json["Error"] as? NSDictionary {
                        error = AppError(data: response)
                        compilition(false,error!)
                    }else{
                        compilition(true,nil)
                    }
                }
            }else {
                compilition(true,nil)
            }
            
        })
        dataTask.resume()
    }
    
}

