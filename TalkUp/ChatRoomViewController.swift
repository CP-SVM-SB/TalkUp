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


    override func viewDidLoad() {
        super.viewDidLoad()
        // Get user's location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Get chatroom info -> members, messages and info stuff
        Client.findChat { (chatID: Int, chatAlreadyExists: Bool) in
            if chatAlreadyExists {
                self.Client.joinChatWithId(id: chatID, onSuccess: { (chatInfo: ChatRoom) in
                    self.chat = chatInfo
                    print("joined chat")
                    self.loadTable()
                })
            }
            else {
                self.Client.createAndJoinChatWithId(id: chatID, onSuccess: { (chatInfo: ChatRoom) in
                    self.chat = chatInfo
                    print("created and joined new chat")
                    self.loadTable()
                })
            }
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

    
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollToBottom()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Client.exitChatWithId(id: self.chat.count) { 
            print("exited chat and ready to segue")
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
        print(" USER INACTIVE ")
        // here is where we will send user activity status to the backend
    }
    
    func userActive(){
        print(" USER ACTIVE ")
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
        //print("LOCATION = \(locValue.latitude) \(locValue.longitude)")
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
