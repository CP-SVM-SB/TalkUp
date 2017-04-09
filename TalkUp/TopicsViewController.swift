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
  
  var rawMessages: String?
  var chatmsg: String?
  
  var keywords = [String]()
  var noChatsWithKeyword = [Int]()
  
  var keywordDict = Dictionary<String, NSMutableArray>()
  var previewVisible = false
  
  var previewChats : NSMutableArray?
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    self.tableView.separatorStyle = .none
    self.tableView.allowsSelection = false
    
    getKeywords()
    
    
    
  }
  
  
  override func viewDidLayoutSubviews() {
    if traitCollection.forceTouchCapability == .available {
      registerForPreviewing(with: self, sourceView: tableView)
    }
  }
  
  
  
  // *** quite bulky
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
      self.keywordApi.performKeywordSearch(textBody: self.rawMessages!, success: { (keys: [String]) in
        self.keywords = keys
        
        for keyW in keys {
          var count = 0
          self.keywordDict[keyW] = [""]    // initialize dict. of nsmutableArr for appending
          
          for msg in revRawMsgs {
            // case-insensitive search
            if msg.text!.lowercased().range(of:keyW.lowercased()) != nil {
              if count > 0 {
                self.keywordDict[keyW]!.add(msg.text!)
              } else {
                self.keywordDict[keyW]?[0] = msg.text!
              }
              count += 1
            }
          }
          
          self.noChatsWithKeyword.append(count)
        }
        
        self.tableView.reloadData()
        
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
    return (self.keywords.count > self.noTopicsMax) ? self.noTopicsMax : self.keywords.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell", for: indexPath) as! TrendCell
    
    cell.noChatsforTopic = self.noChatsWithKeyword[indexPath.row]
    cell.buttonTitle = self.keywords[indexPath.row]
    
    return cell
  }
  
  
  
  
  
  
}
