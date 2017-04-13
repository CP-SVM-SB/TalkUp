//
//  GifsCollectionViewCell.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/13/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class GifsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var urlLabel: UILabel!
    
    var url = String()
    
    
    override func awakeFromNib() {
        
        print("AWAKE FROM NIB: ")
        //urlLabel.text = url
        
    }
    
    
}
