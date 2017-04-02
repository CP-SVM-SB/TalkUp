//
//  TopicsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController {
  
  var rawMessages: String?
  let myParseClient = ParseClient()
  let keywordApi = KeywordClient()
  var chatmsg: String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // get chat msgs
    getRawMessages()
    
  }
  
  
  func getRawMessages() {
    myParseClient.getMessages(onSuccess: { (rawMsgs: [Message]) in
      
      for msg in rawMsgs {
        //self.rawMessages.append(msg.text!)
        self.rawMessages = (self.rawMessages == nil) ? msg.text! : self.rawMessages!+", "+msg.text!
      }
      
      // call keyword API on msgs
      self.keywordApi.getKeywords(textBody: self.rawMessages!)
      
      
    }) { (error: Error) in
      print(error.localizedDescription)
    }
  }
  
}
