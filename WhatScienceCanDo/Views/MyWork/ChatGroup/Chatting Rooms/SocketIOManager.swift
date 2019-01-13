//
//  SocketIOManager.swift
//  ChatAppWithSocket
//
//  Created by MOHAMED on 8/29/18.
//  Copyright © 2018 MOHAMED. All rights reserved.
//

import UIKit
import SocketIO
import Alamofire
import SwiftyJSON
let manager = SocketManager(socketURL: URL(string: ChatUrl + ":3001")!, config: [.log(true), .compress])
let socket = manager.defaultSocket
class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    override init() {
        super.init()
    }
 

    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("add user", nickname)
        
        listenForOtherMessages()
    }
    
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("user left", nickname)
        completionHandler()
    }
    
    
    func sendMessage(message: String, withNickname nickname: String , groupId : Int , userId : Int , vip : Int , image : String) {
        //data, groupId, userId, vip, nickname
        socket.emit("new message", message, groupId , userId , vip , nickname , image)
    }
    
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        
        socket.on("new message" ) { (dataArray, socketAck) -> Void in
            print("Data Array" , dataArray)
            var messageDictionary = [String: AnyObject]()
            let obj = dataArray[0] as! Dictionary<String, Any>

            messageDictionary["message"] = obj["message"] as! String as AnyObject
            messageDictionary["nickname"] = obj["nickname"] as! String as AnyObject
            
         //   messageDictionary["user_id"] = String(describing: obj["user_id"]!) as! String as AnyObject
            messageDictionary["vip"] = obj["vip"] as! String as AnyObject
            messageDictionary["image"] = obj["image"] as! String as AnyObject

            completionHandler(messageDictionary)
        }
    }
    
    func GetAllMessages( group_id : Int ,completionHandler: @escaping (_ messageInfo: [[String: AnyObject]]) -> Void) {
        socket.emit("get messages", group_id)
        socket.on("get messages" ) { (dataArray, socketAck) -> Void in
            //print("Data Array" , dataArray)
            var messageDictionary = [[String: AnyObject]]()
            print("Data Array")
            let obj = dataArray[0] as! [Dictionary<String, AnyObject>]
            for i in obj {
                var messages :Dictionary<String, Any> = [:]
            messages["message"] = i["message"] as! String as AnyObject
              
            messages["user_id"] = String(describing: i["user_id"]!) as AnyObject
            
            let first_name = i["first_name"] as! String as AnyObject
            let second_name = i["last_name"] as! String as AnyObject
            
            messages["nickname"] = (first_name as! String) + " " + (second_name as! String) as AnyObject
           
                messages["username"] = i["email"] as! String as AnyObject

                messages["vip"] = String(describing: i["vip"]!) as AnyObject
                messages["image"] = i["image"]! as! String as AnyObject
                messageDictionary.append(messages as [String : AnyObject])
            }
            completionHandler(messageDictionary)
        }
    }
    private func listenForOtherMessages() {
      //  socket.emit("get messages", 5)
      
        
        /*
        socket.on("login") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        
        socket.on("user left") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("typing") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
 */
    }
    
    
    func sendStartTypingMessage(nickname: String) {
        //socket.emit("typing", nickname)
    }
    
    
    func sendStopTypingMessage(nickname: String) {
        //socket.emit("stop typing", nickname)
    }
}
