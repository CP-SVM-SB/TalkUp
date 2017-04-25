//
//  TrendCell.swift
//  TalkUp
//
//  Created by Tunscopi on 4/2/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class TrendCell: UITableViewCell {
  
  @IBOutlet var flameImageView: UIImageView!
  @IBOutlet weak var topicBTN: UIButton!
  @IBOutlet weak var noChatsAboutThisLabel: UILabel!
  
    var delegate: TopicsViewController?
    var noChatsforTopic: Int?
    var buttonTitle: String! {
    
        
    didSet {
      topicBTN.setTitle("#"+buttonTitle, for:.normal)
      noChatsAboutThisLabel.text = (noChatsforTopic! > 1) ? "\(noChatsforTopic!) chats" : "\(noChatsforTopic!) chat"
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    flameImageView.image = UIImage(named: "flame (2).png")
    flameImageView.tintColor = UIColor.lightGray
  }
  
    @IBAction func didTapTopic(_ sender: UIButton) {

        print("BUTTON TAPPED")
        print("SENDER TAG: ", sender.tag)
        self.delegate?.topicTappedIndex = (self.delegate?.chatIDs[sender.tag])!
        print("JOINING CHAT FROM TOPIC -- CHAT ID =",  self.delegate?.chatIDs[sender.tag])

        
    }
  
}
