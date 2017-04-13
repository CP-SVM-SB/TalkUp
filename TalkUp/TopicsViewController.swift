//
//  TopicsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
  
  @IBOutlet weak var tableView: UITableView!
  
  let myParseClient = ParseClient()
  let keywordApi = WatsonClient()
  
  // -- Settable Vars --
  var noTopicsMax = 7               // max. number of topics you wish to see
  var topicsRollbackLength: Int = 50   // no of recent msgs you wish to use in getting topics [NB]: if 0, ALL messages are used
  
  var noCurrentlyAvailableChats = 0
  var rawMessages: String?
  var chatmsg: String?
  var chatRawMsgs = [String]()
  
  var keywordsWithRelevance = Dictionary <String, Double>()
  var keywordsWithChats = Dictionary<String, NSMutableArray>()
  var keywordsArr = [String]()
  var previewChats : NSMutableArray?
  var noChatsWithKeyword = [Int]()
  
  var chatTopicWithRelevance = Dictionary<String, Double>()
  var chatTopicsArr = [String]()
  var chatIDs = [Int]()
  var nonEmptyChatId = 0
  var keywordID = 0
  var chatCount = 0
  var chatIndex = 0
  
  var revChatMsgs = Dictionary<Int, [Message]>()
  
  
  var firstValSet = false
  var userSettings: UserSettings?
  
  let myDispatchGroup = DispatchGroup()
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    self.tableView.separatorStyle = .none
    self.tableView.allowsSelection = false
    
    myDispatchGroup.enter()
    myParseClient.getChatCount (onSuccess: { (chatCount: Int) in
      print("No. of available chats: \(chatCount+1)")
      self.noCurrentlyAvailableChats = chatCount+1
      self.myDispatchGroup.leave()
    })
    
    myDispatchGroup.notify(queue: .main) {
      self.getIndexChatMsgs(index: self.chatCount)
    }
    
  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    view.backgroundColor = userSettings?.theme?.primaryColor
  }
  
  
  
  
  override func viewDidLayoutSubviews() {
    if traitCollection.forceTouchCapability == .available {
      registerForPreviewing(with: self, sourceView: tableView)
    }
  }
  
  
  
  
  func getIndexChatMsgs(index: Int) {     // lots of moving parts! (hint: async calls)
    var msg: String?
    print("\nrequesting chat(\(index))")
    
    self.myParseClient.getMessagesFromChatWithId(id: index, onSuccess: { (rawChatMsgs: [Message]) in
      print("returned chat(\(index))")
      if rawChatMsgs.isEmpty {} else {  // TODO: limited no. of msgs check to qualify for keyword search
        print ("Chat(\(index)) Non-empty chat found!")
        self.chatIDs.append(index)
        
        // rollback?
        let revMsgs = rawChatMsgs.reversed()
        var ind = 0
        if (self.topicsRollbackLength == 0) {
          for msg in revMsgs { self.chatRawMsgs[self.nonEmptyChatId] = (self.chatRawMsgs[self.nonEmptyChatId] == "") ? msg.text! : self.chatRawMsgs[self.nonEmptyChatId]+", "+msg.text!}
        } else {
          for i in revMsgs.indices {
            if (ind > self.topicsRollbackLength) {break}
            msg = (!self.firstValSet) ? revMsgs[i].text! : msg!+", "+revMsgs[i].text!
            self.firstValSet = true
            ind += 1
          }
        }
        self.chatRawMsgs.append(msg!)
        
        // extract keywords for current chat
        //print("chatID: \(self.chatCount)")
        //print("Texts: \(self.chatRawMsgs[self.chatCount])\n")
        
        self.keywordApi.performKeywordSearch(textBody: self.chatRawMsgs[self.chatCount], success: { (keys: [String : Double]) in
          self.chatTopicWithRelevance = keys
          var chatTopic : String?
          
          // inelegant! extracts element "0" of dictionary keys
          for key in keys.keys {
            //print("Chat(\(self.chatIndex)) Topic: \(key)")
            self.chatTopicsArr.append(key)
            break
          }
          //print("chatTopics Arr: \(self.chatTopicsArr)")
          
          if self.chatTopicsArr.count == self.chatIndex + 1 { // check if a key was returned
            chatTopic = self.chatTopicsArr[self.chatIndex]
            self.keywordsArr.append(chatTopic!)
            
            var count = 0
            self.keywordsWithChats[chatTopic!] = [""]  // initialize dict. of NSMutable Arr for appending
            
            for msg in revMsgs {
              // case-insensitive search
              if msg.text!.lowercased().range(of: (chatTopic?.lowercased())!) != nil {
                if count > 0 {
                  self.keywordsWithChats[chatTopic!]!.add(msg.text!)
                } else {
                  self.keywordsWithChats[chatTopic!]![0] = msg.text!
                }
                count += 1
              }
            }
            self.noChatsWithKeyword.append(count)
          }
          
          self.firstValSet = false
          self.chatCount += 1
          self.chatIndex += 1
          if (self.chatIndex < self.noCurrentlyAvailableChats) {
            var nextIter = self.chatIndex
            self.getIndexChatMsgs(index: nextIter)
            self.tableView.reloadData()
          } else {
            self.tableView.reloadData()
          }
          
        }, failure: { (error: Error) in
          print (error.localizedDescription)
        })
        
     }
    }, onFailure: { (error: Error) in
      print(error.localizedDescription)
    })
  }
  
  
  
  
  
  // *** To be DEPRECATED soon! ***
  func getKeywords() {
    myParseClient.getMessages(onSuccess: { (rawMsgs: [Message]) in
      let revRawMsgs = rawMsgs.reversed()  // rollback purposes
      var index = 0
      
      if (self.topicsRollbackLength == 0) {
        for msg in revRawMsgs {
          self.rawMessages = (self.rawMessages == nil) ? msg.text! : self.rawMessages!+", "+msg.text!
        }
      } else {
        for i in revRawMsgs.indices {
          if (index > self.topicsRollbackLength) {
            break
          }
          self.rawMessages = (self.rawMessages == nil) ? revRawMsgs[i].text! : self.rawMessages!+", "+revRawMsgs[i].text!
          index += 1
        }
      }
      
      
      // watson API call
      self.keywordApi.performKeywordSearch(textBody: self.rawMessages!, success: { (keys: [String : Double]) in
        self.keywordsWithRelevance = keys
        self.keywordsArr = [String](self.keywordsWithRelevance.keys)
        self.tableView.reloadData()   // show keywords right away!
        
        for (keyW, _) in keys {
          var count = 0
          self.keywordsWithChats[keyW] = [""]  // initialize dict. of NSMutable Arr for appending
          
          for msg in revRawMsgs {
            // case-insensitive search
            if msg.text!.lowercased().range(of: keyW.lowercased()) != nil {
              if count > 0 {
                self.keywordsWithChats[keyW]!.add(msg.text!)
              } else {
                self.keywordsWithChats[keyW]?[0] = msg.text!
              }
              count += 1
            }
          }
          self.noChatsWithKeyword.append(count)
        }
        
        self.tableView.reloadData()   // show no. of chats when processing is complete
        
      }, failure: { (error: Error) in
        print (error.localizedDescription)
      })
      
    }) { (error: Error) in
      print(error.localizedDescription)
    }
  }
  
  @IBAction func unwindToTopics (segue: UIStoryboardSegue) {
    
  }
  
  // ------------------------ PREPARE FOR SEGUE --------------------------
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toSettings"{
      let settingsVC = segue.destination as! SettingsTableViewController
      settingsVC.userSettings = self.userSettings
    }
    
    if segue.identifier == "topicsToChatsSegue"{
      let navC = segue.destination as! UINavigationController
      let chatVC = navC.viewControllers.first as! ChatRoomViewController
      chatVC.userSettings = self.userSettings
    }
    
    
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.keywordsArr.count > self.noTopicsMax) ? self.noTopicsMax : self.keywordsArr.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell", for: indexPath) as! TrendCell
    
    cell.noChatsforTopic = self.noChatsWithKeyword[indexPath.row]
    cell.buttonTitle = self.keywordsArr[indexPath.row]
    
    return cell
  }
  
  
  
  
  
  
}
