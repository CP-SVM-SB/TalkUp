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

  var rawMessages: String?
  var chatmsg: String?
  var keywords = [String]()
  var noTrendsMax = 7    //set max. number of trends you wish to see
  
  /*TODO:
  - Set how far back trends should go (time-elapsed or no. of msgs to evaluate)
  - Make trends clickable and display a preview of a couple chats w/ keyword
  */
  
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
      
      for msg in rawMsgs {
        self.rawMessages = (self.rawMessages == nil) ? msg.text! : self.rawMessages!+", "+msg.text!
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
    return (self.keywords.count > self.noTrendsMax) ? self.noTrendsMax : self.keywords.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell", for: indexPath) as! TrendCell
    cell.trendLabel.text = self.keywords[indexPath.row]

    return cell
  }


}
