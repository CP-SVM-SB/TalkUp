//
//  PreviewChatsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 4/8/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class PreviewChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var previewTableView: UITableView!
  @IBOutlet weak var topicLabel: UILabel!
  
  var topic:String?
  var chatsWithKeyWord: NSMutableArray?
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    topicLabel.text = topic!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    previewTableView.delegate = self
    previewTableView.dataSource = self
    
    previewTableView.tableFooterView = UIView()
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (chatsWithKeyWord?.count)!
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = previewTableView.dequeueReusableCell(withIdentifier: "PreviewChatsCell") as! PreviewChatsCell
    
    if let chatsArr = chatsWithKeyWord as? Any as? [String] {
      cell.chatMessageForTopic.text = chatsArr[indexPath.row]
    }
    
    
    return cell
  }
  
  
  
}
