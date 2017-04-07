//
//  TrendCell.swift
//  TalkUp
//
//  Created by Tunscopi on 4/2/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class TrendCell: UITableViewCell {
  
  
  @IBOutlet weak var topicBTN: UIButton!
  @IBOutlet weak var noChatsAboutThisLabel: UILabel!
  
  var noChatsforTopic: Int?
  
  var buttonTitle: String! {
    didSet {
      topicBTN.setTitle(buttonTitle, for:.normal)
      noChatsAboutThisLabel.text = (noChatsforTopic! > 1) ? "\(noChatsforTopic!) chats" : "\(noChatsforTopic!) chat"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  
}
