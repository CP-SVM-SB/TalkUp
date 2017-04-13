//
//  ChatRoomViewController.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation


class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
  
    @IBOutlet var `switch`: UISwitch!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var chatView: UIView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var messages: [Message] = []
    var Client = ParseClient()
    var flag = false
    var user = User()
    var chat = ChatRoom()
    var activity: [Int] = []
    var timerFlag = false

    var userSettings: UserSettings?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.switch.isEnabled = true
        self.switch.isOn = false
        
        
        // Get user's location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        //make sure the location is saved before we find the close by chat
    //self.location
        // Get chatroom info -> members, messages and info stuff
        /*
        while (self.chat.location?.longitude == nil) {
            // wait till we have a location
        }
 */
        
        
        
        
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.Client.findCloseByChat(userLocation: self.chat.location!, onSuccess: { (code: Int) in
                self.Client.joinChatWithId(id: code, onSuccess: { (chatInfo: ChatRoom) in
                    self.chat = chatInfo
                    if self.chat.open == 1 {
                        self.switch.isOn = true
                    }
                    else {
                        self.switch.isOn = false
                    }
                    print("joined chat based on location")
                    self.loadTable()
                    let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ChatRoomViewController.refreshChat), userInfo: nil, repeats: true)
                })
            }, onFailure: { 
                self.Client.findChat { (chatID: Int, chatAlreadyExists: Bool) in
                    if chatAlreadyExists {
                        self.Client.joinChatWithId(id: chatID, onSuccess: { (chatInfo: ChatRoom) in
                            self.chat = chatInfo
                            if self.chat.open == 1 {
                                self.switch.isOn = true
                            }
                            else {
                                self.switch.isOn = false
                            }
                            print("joined chat")
                            self.loadTable()
                            let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ChatRoomViewController.refreshChat), userInfo: nil, repeats: true)
                        })
                    }
                    else {
                        self.Client.createAndJoinChatWithId(id: chatID, onSuccess: { (chatInfo: ChatRoom) in
                            self.chat = chatInfo
                            if self.chat.open == 1 {
                                self.switch.isOn = true
                            }
                            else {
                                self.switch.isOn = false
                            }
                            print("created and joined new chat")
                            self.loadTable()
                            let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ChatRoomViewController.refreshChat), userInfo: nil, repeats: true)
                        })
                    }
                }
            })
        }
    
    
        
        
        
        
        // add the current user to the chat room
        //chat.members.append(user!)
        
        // push the new chatroom
        

        
        
        let currentUser = PFUser.current()!
        if let uname = currentUser["username"] as? String {
          user.username = uname
        } else {
          user.username = "unidentified user"
        }
        
        

        
        // Adjust User Interface

        sendButton.layer.cornerRadius = 5.0
        sendButton.clipsToBounds = true


        // For keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.chatView.addGestureRecognizer(tapGesture)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.loadTable()

    }

    func refreshChat()
    {
        self.Client.getDataForChatWithId(id: self.chat.count) { (listOfMessages: [Message], open: Bool, activityList: [Int]) in
            self.messages = listOfMessages
            self.tableView.reloadData()
            if open {
                self.switch.isOn = true
            }
            else {
                self.switch.isOn = false
            }
            self.activity = activityList
            self.scrollToBottom()
            self.timerFlag = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollToBottom()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        view.backgroundColor = userSettings?.theme?.primaryColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    
 // ------------------------ PREPARE FOR SEGUE --------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Client.getInfoForChatWithId(id: self.chat.count) { (room: ChatRoom) in
            if room.memberCount <= 1{
                self.Client.cleanupChatWithId(id: room.count, onSuccess: { 
                    print("cleaned up chat")
                })
            }
        }
        Client.exitChatWithId(id: self.chat.count) { 
            print("exited chat and ready to segue")
        }

        
        if (segue.identifier == "unwindToTopics") {
            Client.exitChatWithId(id: self.chat.count) {
                print("exited chat")
            }
        }
        
        if (segue.identifier == "toGifs"){
            
            let gifsVC = segue.destination as! GifsViewController
            gifsVC.userSettings = self.userSettings

        }
    
        
    }
    
    
    @IBAction func onSendButton(_ sender: Any) {
        
        let message = Message()
        message.from = user.username!
        message.text = messageTextField.text
        messageTextField.text = ""
        if message.text != "" {
            self.Client.sendMessageToChatWithId(message: message, id: self.chat.count, onSuccess: {
                self.loadTable()
                self.scrollToBottom()
            }) { (error: Error) in
                print(error.localizedDescription)
            }
        }
            
        
    }
    

    func userInactive(){
        print("------ USER INACTIVE -------- ")
        if self.timerFlag {
            Client.changeToInactive(id: self.chat.count)
        }
        // here is where we will send user activity status to the backend
    }
    
    func userActive(){
        if self.timerFlag {
            Client.changeToActive(id: self.chat.count)
        }
        // here too
    }

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {

    }

    // ---------- SCROLL TO BOTTOM FUNCTION: Added By SVM ---------
    func scrollToBottom() {
        tableView.reloadData()
        tableView.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(tableView.contentSize.height - tableView.frame.size.height))
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.messageLabel.text = (messages[indexPath.row].text!)
        if messages[indexPath.row].from == user.username {
            cell.messageLabel.textAlignment = NSTextAlignment.right
        }
        
        return cell

    }

    func loadTable() {
        Client.getMessagesFromChatWithId(id: self.chat.count, onSuccess: { (listOfMessages:[Message]) in
            self.messages = listOfMessages
            self.tableView.reloadData()
            self.scrollToBottom()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }

    func keyboardWillShow(sender: NSNotification) {
        if self.flag == false {
          let userInfo:NSDictionary = sender.userInfo! as NSDictionary
          let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
          let keyboardRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keyboardRectangle.height
          
          self.view.frame.origin.y -= keyboardHeight
          self.flag = true
        }

    }

    func keyboardWillHide(sender: NSNotification) {
        if self.flag == true {
          let userInfo:NSDictionary = sender.userInfo! as NSDictionary
          let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
          let keyboardRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keyboardRectangle.height
          
          self.view.frame.origin.y += keyboardHeight
          self.flag = false
        }
    }


    func tap(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
          self.chatView.endEditing(true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.chat.location?.longitude = locValue.longitude
        self.chat.location?.latitude = locValue.latitude
        //print("LOCATION = \(locValue.latitude) \(locValue.longitude)")
    }

    @IBAction func changedSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.Client.openChatWithId(id: self.chat.count, location: self.chat.location!, onSuccess: {
                self.Client.queueChatWithId(id: self.chat.count, location: self.chat.location!, onSuccess: { 
                    print("queued")
                })
                print("location added and chat is open")
            })
        }
        else {
            self.Client.closeChatWithId(id: self.chat.count, onSuccess: {
                self.Client.dequeueChatWithId(id: self.chat.count, onSuccess: { 
                    print("closed and qequeued")
                })
            })
        }
    }
    
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
