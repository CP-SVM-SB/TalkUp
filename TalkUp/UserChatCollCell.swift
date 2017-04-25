//
//  UserChatCollCell.swift
//  TalkUp
//
//  Created by Tunscopi on 4/25/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class UserChatCollCell: UICollectionViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var chatBubbleView: UIView!
  @IBOutlet weak var userChatLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    userChatLabel.textColor = UIColor.white
    profileImageView.layer.cornerRadius = 15
    chatBubbleView.layer.cornerRadius = 10
    profileImageView.clipsToBounds = true
    chatBubbleView.clipsToBounds = true
  }
}
