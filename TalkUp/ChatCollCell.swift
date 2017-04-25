//
//  ChatCollCell.swift
//  TalkUp
//
//  Created by Tunscopi on 4/24/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ChatCollCell: UICollectionViewCell {
    
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var chatBubbleView: UIView!
  @IBOutlet weak var chatLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    profileImageView.layer.cornerRadius = 15
    chatBubbleView.layer.cornerRadius = 10
    profileImageView.clipsToBounds = true
    chatBubbleView.clipsToBounds = true
  }
}
