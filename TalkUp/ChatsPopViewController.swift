//
//  ChatsPopViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 4/9/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ChatsPopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var chatTopicLabel: UILabel!
  
  var chatTopic: String?
  var chatsWithKeyWord: NSMutableArray?
  
  
  override func viewWillAppear(_ animated: Bool) {
    chatTopicLabel.text = chatTopic!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (chatsWithKeyWord?.count)!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsPopCell") as! ChatsPopCell
    
    if let chatsArr = chatsWithKeyWord as? Any as? [String] {
      cell.chatMessageForTopic.text = chatsArr[indexPath.row]
    }
    
    return cell
    
  }
}
