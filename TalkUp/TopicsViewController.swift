//
//  TopicsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
  typealias CompletionHandler = (_ onSuccess:Bool) -> Void
  
  /*func queryWatson (textBody: String, querySuccess: (), completionHandler: CompletionHandler) {
    var flag: Bool?
   
    if querySuccess {
      flag = true
    } else {
      flag = false
    }
    
    completionHandler(flag!)
  }
*/
  
  @IBOutlet weak var tableView: UITableView!
  
  let myParseClient = ParseClient()
  let keywordApi = WatsonClient()
  
  // -- Settable Vars --
  var noTopicsMax = 7               // max. number of topics you wish to see
  var topicsRollbackLength: Int = 50   // no of recent msgs you wish to use in getting topics [NB]: if 0, ALL messages are used
  
  var noCurrentlyAvailableChats: Int?
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
  
  var firstValSet = false
  var userSettings: UserSettings?
  
  let myDispatchGroup = DispatchGroup()
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    self.tableView.separatorStyle = .none
    self.tableView.allowsSelection = false
    
    getParticularChatMsgs()
    
    //getKeywords()
    
  }
  
  
  override func viewDidLayoutSubviews() {
    if traitCollection.forceTouchCapability == .available {
      registerForPreviewing(with: self, sourceView: tableView)
    }
  }
  
  
  func getParticularChatMsgs() {
    myParseClient.getChatCount (onSuccess: { (chatCount: Int) in
      print("No. of available chats: \(chatCount)")
      
      for index in 1 ... chatCount {
        //self.myDispatchGroup.enter()
        var msg: String?
        self.myParseClient.getMessagesFromChatWithId(id: index, onSuccess: { (rawChatMsgs: [Message]) in
          
          if rawChatMsgs.isEmpty {} else {  // TODO: check for limited no. of msgs to qualify for keyword search
            print ("Chat:\(index) Non-empty chat found!")
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
                ind += 1
                self.firstValSet = true
              }
              self.chatRawMsgs.append(msg!)
              print(self.chatRawMsgs[self.nonEmptyChatId])
            }
            
            // extract keywords
            self.keywordApi.performKeywordSearch(textBody: self.chatRawMsgs[self.keywordID], success: { (keys: [String : Double]) in
              print(self.keywordID)
              self.chatTopicWithRelevance = keys
              var chatIndex = 0

              // not elegant! extracts element "0" of dictionary keys
              for key in keys.keys {
                self.chatTopicsArr.append(key)
                break
              }
              let chatTopic = self.chatTopicsArr[chatIndex]
              self.keywordsArr.append(chatTopic)
              
              var count = 0
              self.keywordsWithChats[chatTopic] = [""]  // initialize dict. of NSMutable Arr for appending
              
              for msg in revMsgs {
                // case-insensitive search
                if msg.text!.lowercased().range(of: chatTopic.lowercased()) != nil {
                  //print(msg.text!)
                  if count > 0 {
                    self.keywordsWithChats[chatTopic]!.add(msg.text!)
                  } else {
                    self.keywordsWithChats[chatTopic]!.add(msg.text!)
                  }
                  count += 1
                }
                self.noChatsWithKeyword.append(count)
              }
              
              self.tableView.reloadData()   // show no. of chats when available
              chatIndex += 1
              
              print("Chat(\(index)) keyWord Request Complete!")
              //self.myDispatchGroup.leave()
              
            }, failure: { (error: Error) in
              print (error.localizedDescription)
            })
            self.keywordID += 1
            self.firstValSet = false
          }
          
        }, onFailure: { (error: Error) in
          print(error.localizedDescription)
        })
      }
      
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
                self.keywordsWithChats[keyW]!.add(msg.text!)
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
