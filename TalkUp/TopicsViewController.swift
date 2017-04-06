//
//  TopicsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  let myParseClient = ParseClient()
  let keywordApi = WatsonClient()
  
  // -- Settable Vars --
  var noTopicsMax = 7               // max. number of topics you wish to see
  var topicsRollbackLength: Int = 20   // no of messages you wish to use in topics/keywords [NB]: if 0, ALL messages are used

  var rawMessages: String?
  var chatmsg: String?
  var keywords = [String]()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    self.tableView.separatorStyle = .none
    self.tableView.allowsSelection = false
    
    getKeywords()
    
  }
  
  
  func getKeywords() {
    myParseClient.getMessages(onSuccess: { (rawMsgs: [Message]) in
      var index = 0

      if (self.topicsRollbackLength == 0) {
        for msg in rawMsgs {
          self.rawMessages = (self.rawMessages == nil) ? msg.text! : self.rawMessages!+", "+msg.text!
        }
      } else {
        while (index < self.topicsRollbackLength && index < rawMsgs.count) {
          self.rawMessages = (self.rawMessages == nil) ? rawMsgs[index].text! : self.rawMessages!+", "+rawMsgs[index].text!
          index += 1
        }
      }
      
      // watson API call
      self.keywordApi.performKeywordSearch(textBody: self.rawMessages!, success: { (keys: [String]) in
        self.keywords = keys
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
    cell.trendLabel.text = self.keywords[indexPath.row]
    
    return cell
  }
  
  
}
