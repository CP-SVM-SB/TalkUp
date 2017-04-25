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
  var userMessage = false
  
  override func awakeFromNib() {
    if userMessage {
      //chatBubbleView.align
    }
    profileImageView.layer.cornerRadius = 5
  }
}
