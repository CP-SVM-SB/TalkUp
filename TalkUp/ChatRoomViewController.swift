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

protocol ChatVCDelegate {
  func sendValues(gifUrl: String, gifData: Data)
}


class ChatRoomViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ChatVCDelegate {
  
  
  @IBOutlet var `switch`: UISwitch!
  @IBOutlet var chatView: UIView!
  @IBOutlet var messageTextField: UITextField!
  @IBOutlet var sendButton: UIButton!
  @IBOutlet weak var gifButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var leavingChat = false
  var delegate: TopicsVCDelegate?
  var messages: [Message] = []
  var Client = ParseClient()
  var flag = false
  var user = User()
  var chat = ChatRoom()
  var activity: [Int] = []
  var timerFlag = false
  var gifData = Data()
  var gifUrl = String()
  var topicChatIndex: Int?
  var userSettings: UserSettings?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    
    self.switch.isEnabled = true
    self.switch.isOn = false
    
    self.chat.location?.longitude = Double(UserDefaults.standard.string(forKey: "longitude")!)
    self.chat.location?.latitude = Double(UserDefaults.standard.string(forKey: "latitude")!)
    print("CONFIRMATION: ", topicChatIndex)
    
    //make sure the location is saved before we find the close by chat
    //self.location
    // Get chatroom info -> members, messages and info stuff
    /*
     while (self.chat.location?.longitude == nil) {
     // wait till we have a location
     }
     */
    
    
    /*
     let when = DispatchTime.now() + 5 // change 5 to desired number of seconds
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
     print("joined chat \(self.chat.count) based on location")
     
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
     */
    
    if topicChatIndex != nil {
      self.Client.joinChatWithId(id: topicChatIndex!, onSuccess: { (chatInfo: ChatRoom) in
        self.chat = chatInfo
        if self.chat.open == 1 {
          self.switch.isOn = true
        }
        else {
          self.switch.isOn = false
        }
        print("joined chat \(self.topicChatIndex!) based on topic!")
        
        self.loadTable()
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatRoomViewController.refreshChat), userInfo: nil, repeats: true)
      })
    } else {
    
    self.Client.findCloseByChat(userLocation: self.chat.location!, onSuccess: { (code: Int) in
      self.Client.joinChatWithId(id: code, onSuccess: { (chatInfo: ChatRoom) in
        self.chat = chatInfo
        if self.chat.open == 1 {
          self.switch.isOn = true
        }
        else {
          self.switch.isOn = false
        }
        print("joined chat \(self.chat.count) based on location!")
        
        self.loadTable()
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatRoomViewController.refreshChat), userInfo: nil, repeats: true)
      })
    }, onFailure: {
      self.Client.findChat { (chatID: Int, chatAlreadyExists: Bool) in
        if chatAlreadyExists {
          self.Client.joinChatWithId(id: chatID, onSuccess: { (chatInfo: ChatRoom) in
            if chatInfo.memberCount < 2 {
//                //self.Client.sendInitialMessageToChatWithId(id: chatInfo.count, onSuccess: {
//                print("Initial message sent")
//              }, onFailure: { (error: Error) in
//                print("failed to send initial message")
//              })
            }
            self.chat = chatInfo
            if self.chat.open == 1 {
              self.switch.isOn = true
            }
            else {
              self.switch.isOn = false
            }
            print("joined chat")
            self.loadTable()
            let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatRoomViewController.refreshChat), userInfo: nil, repeats: true)
          })
        }
        else {
          self.Client.createAndJoinChatWithId(id: chatID, onSuccess: { (chatInfo: ChatRoom) in
//            //self.Client.sendInitialMessageToChatWithId(id: chatInfo.count, onSuccess: {
//              print("Initial message sent")
//            }, onFailure: { (error: Error) in
//              print("failed to send initial message")
//            })
            self.chat = chatInfo
            if self.chat.open == 1 {
              self.switch.isOn = true
            }
            else {
              self.switch.isOn = false
            }
            print("created and joined new chat")
            self.loadTable()
            let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatRoomViewController.refreshChat), userInfo: nil, repeats: true)
            
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
    
  }
  
  func refreshChat()
  {
    self.Client.getDataForChatWithId(id: self.chat.count) { (listOfMessages: [Message], open: Bool, activityList: [Int]) in
      self.messages = listOfMessages
      self.collectionView.reloadData()
      if open {
        self.switch.isOn = true
      }
      else {
        self.switch.isOn = false
      }
      self.activity = activityList
      //self.scrollToBottom()  this is unintuitive for user
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
  
  @IBAction func onLeaveChat(_ sender: Any) {
    
    self.leavingChat = true
    
    if self.chat.memberCount <= 1 {
      self.Client.cleanupChatWithId(id: self.chat.count, onSuccess: {
        //print("cleaned up chat")
        self.Client.exitChatWithId(id: self.chat.count) {
          //print("exited chat and ready to segue")
        }
        
      })
    }
    self.leavingChat = true

    self.performSegue(withIdentifier: "unwindToTopics", sender: self)
  }
  
  // ------------------------ PREPARE FOR SEGUE --------------------------
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    Client.getInfoForChatWithId(id: self.chat.count) { (room: ChatRoom) in
      if room.memberCount <= 1{
        self.Client.cleanupChatWithId(id: room.count, onSuccess: {
          print("cleaned up chat")
          self.Client.exitChatWithId(id: self.chat.count) {
            print("exited chat and ready to segue")
          }
        })
      }
    }
    
    
    
    if (segue.identifier == "unwindToTopics") {
      Client.exitChatWithId(id: self.chat.count) {
        print("exited chat")
      }
        
      if self.leavingChat == false {
        self.delegate?.startTimer()
        
      }
      
    }
    
    if (segue.identifier == "toGifs"){
      
      let gifsVC = segue.destination as! GifsViewController
      gifsVC.userSettings = self.userSettings
      
    }
    
    
  }
  
  
  @IBAction func onSendButton(_ sender: Any) {
    
    let message = Message()
    message.from = userSettings?.username
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
  
  func sendValues(gifUrl: String, gifData: Data){
    self.gifUrl = gifUrl
    self.gifData = gifData
    //print("GIFURL: ", gifUrl, "    GIFDATA: ", gifData)
    self.messageTextField.text = gifUrl
  }
  
  @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    
  }
  
  // ---------- SCROLL TO BOTTOM FUNCTION: Added By SVM ---------
  func scrollToBottom() {
    collectionView.reloadData()
    collectionView.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(collectionView.contentSize.height - collectionView.frame.size.height))
  }
  
  func loadTable() {
    //To save the string
    let userDefaults = Foundation.UserDefaults.standard
    userDefaults.set( "\(self.chat.count)", forKey: "chatId")
    
    Client.getMessagesFromChatWithId(id: self.chat.count, onSuccess: { (listOfMessages:[Message]) in
      self.messages = listOfMessages
      self.collectionView.reloadData()
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
  
  @IBAction func didTapGif(_ sender: Any) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let gifsVC = storyboard.instantiateViewController(withIdentifier :"gifsVC") as! GifsViewController
    
    gifsVC.delegate = self
    self.present(gifsVC, animated: true, completion: nil)
    
    
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
  
  //  --- Collection View functions ---
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.messages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if (messages[indexPath.row].from == userSettings?.username) {
      let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserChatCollCell", for: indexPath) as! UserChatCollCell
      userCell.userChatLabel.text = messages[indexPath.row].text!
      userCell.profileImageView.image = userSettings?.profileImage
      userCell.usernameLabel.text = userSettings?.username
      userCell.chatBubbleView.backgroundColor = UIColor.appleBlue()
      return userCell

    } else {
      let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCollCell", for: indexPath) as! ChatCollCell
      otherCell.chatLabel.text = messages[indexPath.row].text!
      otherCell.profileImageView.image = UIImage(named: "animationChatIcon")
      otherCell.usernameLabel.text = messages[indexPath.row].from
      otherCell.chatBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
      return otherCell
    }
    
  }
  
}

extension UIColor {
  static func appleBlue() -> UIColor {
    return UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
  }
}










