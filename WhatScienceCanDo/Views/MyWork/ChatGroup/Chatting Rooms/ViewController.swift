//
//  ViewController.swift
//  ChatAppWithSocket
//
//  Created by MOHAMED on 8/29/18.
//  Copyright © 2018 MOHAMED. All rights reserved.
//

import UIKit
import SocketIO
//Chat url: https://scoopchat.herokuapp.com/



class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
  //  let manager = SocketManager(socketURL: URL(string: "https://scoopchat.herokuapp.com/")!, config: [.log(true), .compress])
   // let socket = manager.defaultSocket
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }
            
            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
            }
            
            ack.with("Got your currentAmount", "dude")
        }
        
        socket.connect()
        /*
        self.addHandlers()
        self.socket.connect()
        // Do any additional setup after loading the view, typically from a nib.
 */
    }
    
    /*
    func askForNickname() {
        let alertController = UIAlertController(title: "SocketChat", message: "Please enter a nickname:", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
            let textfield = alertController.textFields![0]
            if textfield.text?.characters.count == 0 {
                self.askForNickname()
            }else {
                self.nickname = textfield.text
                
                SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: self.nickname, completionHandler: { (userList) -> Void in
                    DispatchQueue.async(DispatchQueue.main(), { () -> Void in
                        if userList != nil {
                            self.users = userList
                            self.tblUserList.reloadData()
                            self.tblUserList.hidden = false
                        }
                    })
                })
            }
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func addHandlers()
    {/*
        socket.on("updatechat"){ data, ack in
            
            print("Chat messages \(data)")
            
            self.arrayText.append(data[1] as! String)
            self.arrayName.append(data[0] as! String)
            self.tableView.reloadData()
            let indexpath = NSIndexPath(forRow: self.arrayName.count-1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexpath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
        socket.on("updaterooms"){ data, ack in
            print("Update room data \(data)")
        }
 */
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

*/
}


