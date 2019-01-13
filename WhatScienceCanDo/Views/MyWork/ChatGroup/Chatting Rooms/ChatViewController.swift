//
//  ChatViewController.swift
//  ChatAppWithSocket
//
//  Created by MOHAMED on 9/2/18.
//  Copyright © 2018 MOHAMED. All rights reserved.
//

import UIKit
import Kingfisher
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate {
  
    lazy var Notification : UIBarButtonItem = {
        let image = UIImage.init(named: "AstraLogo")!.withRenderingMode(.alwaysOriginal)
        
        
        let Notification = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(NotifictionFunction))
        return Notification
    }();
    
    @IBOutlet weak var tblChat: UITableView!
    
    @IBOutlet weak var lblOtherUserActivityStatus: UILabel!
    
    @IBOutlet weak var tvMessageEditor: UITextView!
    
    @IBOutlet weak var conBottomEditor: NSLayoutConstraint!
    
    @IBOutlet weak var lblNewsBanner: UILabel!
    
    
    
    var nickname: String!
    
    var chatMessages = [[String: AnyObject]]()
    
    @IBOutlet weak var ChatTitle: UILabel!
    var bannerLabelTimer: Timer!
    var groupId : Int!
    var ChatName : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.ChatName != nil {
            self.ChatTitle.text = ChatName
            self.title = ChatName
        }
        // Do any additional setup after loading the view.
        
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectedUserUpdateNotification(notification:)), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDisconnectedUserUpdateNotification(notification:)), name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTypingNotification(notification:)), name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)
        
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeGestureRecognizer)
        SocketIOManager.sharedInstance.GetAllMessages(group_id: self.groupId) { (messageInfo) in
            
            self.chatMessages = messageInfo
            self.tblChat.reloadData()
            self.scrollToBottom()
            
        }
        self.navigationItem.setRightBarButtonItems([Notification], animated: true)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
        configureNewsBannerLabel()
        configureOtherUserActivityLabel()
        
        tvMessageEditor.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
             let parseQueue = DispatchQueue(label: "com.socketio.parseQueue", attributes: .concurrent)
            parseQueue.async {
                self.chatMessages.append(messageInfo)
                self.tblChat.reloadData()
                self.scrollToBottom()
            }
            /*
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.chatMessages.append(messageInfo)
                self.tblChat.reloadData()
                self.scrollToBottom()
            })
 */
        }
    }
    @objc func NotifictionFunction() {
        
    }
    func scrollToBottom() {
       
            if self.chatMessages.count > 0 {
                 let lastRowIndexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                self.tblChat.scrollToRow(at: lastRowIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        
 
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        guard let text = self.tvMessageEditor.text , !text.isEmpty else {return}
        if tvMessageEditor.text.count > 0 {
            var messageDictionary = [String: AnyObject]()

            messageDictionary["nickname"] = "Me" as AnyObject
            messageDictionary["user_id"] = ApiToken.GetItem(Key: "user_id") as AnyObject
            messageDictionary["vip"] = ApiToken.GetItem(Key: "vip") as AnyObject
            messageDictionary["image"] = CURRENT_USER?.image! as AnyObject

            messageDictionary["message"] = tvMessageEditor.text as AnyObject
            self.chatMessages.append(messageDictionary)
            self.tblChat.reloadData()
            let UserId = ApiToken.GetItem(Key: "user_id")
            var vip = ApiToken.GetItem(Key: "vip")
            var image = CURRENT_USER?.image!
            print("Group Id" , self.groupId)
            print("UserId Id" , UserId)
            print("vip Id" , vip)
            if  vip == "" {
                vip = "0"
            }
            SocketIOManager.sharedInstance.sendMessage(message: tvMessageEditor.text!, withNickname: nickname, groupId: self.groupId, userId: Int(UserId)!, vip: Int(vip)! , image: image!)
            tvMessageEditor.text = ""
            tvMessageEditor.resignFirstResponder()
            self.scrollToBottom()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: IBAction Methods

    
    
    // MARK: Custom Methods
    
    func configureTableView() {
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "idCellChat")
        tblChat.estimatedRowHeight = 300
        
        tblChat.rowHeight = UITableViewAutomaticDimension
        tblChat.tableFooterView = UIView()
        
    }
    
    
    func configureNewsBannerLabel() {
        lblNewsBanner.layer.cornerRadius = 15.0
        lblNewsBanner.clipsToBounds = true
        lblNewsBanner.alpha = 0.0
    }
    
    
    func configureOtherUserActivityLabel() {
        lblOtherUserActivityStatus.isHidden = true
        lblOtherUserActivityStatus.text = ""
    }
    
    
    @objc func handleKeyboardDidShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                conBottomEditor.constant = keyboardFrame.size.height
                view.layoutIfNeeded()
            }
        }
    }
    
    
    @objc func handleKeyboardDidHideNotification(notification: NSNotification) {
        conBottomEditor.constant = 0
        view.layoutIfNeeded()
    }
    
    

    
    func showBannerLabelAnimated() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 1.0
            
        }) { (finished) -> Void in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: "hideBannerLabel", userInfo: nil, repeats: false)
        }
    }
    
    
    func hideBannerLabel() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 0.0
            
        }) { (finished) -> Void in
        }
    }
    
    
    
    override func dismissKeyboard() {
        if tvMessageEditor.isFirstResponder {
            tvMessageEditor.resignFirstResponder()
            
            SocketIOManager.sharedInstance.sendStopTypingMessage(nickname: nickname)
        }
    }
    
    
    @objc func handleConnectedUserUpdateNotification(notification: NSNotification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["nickname"] as? String
        lblNewsBanner.text = "User \(connectedUserNickname!.uppercased()) was just connected."
        showBannerLabelAnimated()
    }
    
    
    @objc func handleDisconnectedUserUpdateNotification(notification: NSNotification) {
        let disconnectedUserNickname = notification.object as! String
        lblNewsBanner.text = "User \(disconnectedUserNickname.uppercased()) has left."
        showBannerLabelAnimated()
    }
    
    
    @objc func handleUserTypingNotification(notification: NSNotification) {
        if let typingUsersDictionary = notification.object as? [String: AnyObject] {
            var names = ""
            var totalTypingUsers = 0
            for (typingUser, _) in typingUsersDictionary {
                if typingUser != nickname {
                    names = (names == "") ? typingUser : "\(names), \(typingUser)"
                    totalTypingUsers += 1
                }
            }
            
            if totalTypingUsers > 0 {
                let verb = (totalTypingUsers == 1) ? "is" : "are"
                
                lblOtherUserActivityStatus.text = "\(names) \(verb) now typing a message..."
                lblOtherUserActivityStatus.isHidden = false
            }
            else {
                lblOtherUserActivityStatus.isHidden = true
            }
        }
        
    }
    
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellChat", for: indexPath) as! ChatCell
        cell.lblChatMessage.layer.borderWidth = 0.5
        
        //151 , 58 , 103
        cell.lblChatMessage.layer.borderColor = UIColor(red: 151/255, green: 58/255, blue: 103/255, alpha: 1).cgColor
        cell.lblChatMessage.layer.masksToBounds = true
        cell.lblChatMessage.layer.cornerRadius = 5
        cell.lblChatMessage.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        let currentChatMessage = chatMessages[indexPath.row]
        
        let message = currentChatMessage["message"] as! String
     
        cell.UserName.text = currentChatMessage["nickname"] as? String
        let userimage =  currentChatMessage["image"] as? String

        cell.UserAvatar.layer.cornerRadius = cell.UserAvatar.frame.height / 2
        let url = URL(string : SP_ImageUrl +  userimage!)
        print("Image Url " , url)
       
        cell.UserAvatar.layer.masksToBounds = true

        _ = currentChatMessage["message"] as! String
        print("Token" , ApiToken.GetItem(Key: "user_id") )
        if let sender_id = currentChatMessage["user_id"] {
            print("Sender Id" , sender_id)

            if String(describing: sender_id) == ApiToken.GetItem(Key: "user_id") {
            print("Logged In")
            cell.UserName.text = "Me"
            cell.UserName.textAlignment = NSTextAlignment.right
           // cell.lblChatMessage.textAlignment = NSTextAlignment.right

            cell.MyAvatar.isHidden = false
            cell.UserAvatar.isHidden = true

                let url = URL(string : SP_ImageUrl + (CURRENT_USER?.image)!)
                cell.MyAvatar.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "avatarmale"), options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    cell.MyAvatar.layer.cornerRadius = cell.MyAvatar.frame.height / 2
                    cell.MyAvatar.layer.masksToBounds = true
                })
              

        }else {
                print("User" )
                cell.UserAvatar.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "avatarmale"), options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    cell.UserAvatar.image = image
                    cell.UserAvatar.layer.cornerRadius = cell.UserAvatar.frame.height / 2
                })
                cell.UserName.textAlignment = NSTextAlignment.left

                cell.lblChatMessage.textAlignment = NSTextAlignment.left
                cell.MyAvatar.isHidden = true
                cell.UserAvatar.isHidden = false
        }
        }
        let vip =  currentChatMessage["vip"] as? String
        if  vip == "1" {
             cell.UserName.textColor = UIColor(red: 143/255, green: 103/255, blue: 2/255, alpha: 1)
        }else {
            cell.UserName.textColor = .black
        }
        cell.lblChatMessage.text = message
      //  cell.lblMessageDetails.text = "by \(senderNickname.uppercased()) @ \(messageDate)"
        
     //   cell.lblChatMessage.textColor = UIColor.darkGray
        
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        SocketIOManager.sharedInstance.sendStartTypingMessage(nickname: nickname)
        
        return true
    }
    
    
    // MARK: UIGestureRecognizerDelegate Methods
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
   
}
extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
}
