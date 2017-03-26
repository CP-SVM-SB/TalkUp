//
//  ChatCell.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/26/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
