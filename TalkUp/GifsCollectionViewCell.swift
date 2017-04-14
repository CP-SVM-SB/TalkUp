//
//  GifsCollectionViewCell.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/13/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class GifsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var gifImageView: UIImageView!

    
    var url = String()
    var delegate: GifsViewController?
    
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func didSelectGif(_ sender: UIButton) {
        
        if selectButton.isSelected  == false {
            selectButton.isSelected = true
            
            self.delegate?.resetSelection()
            self.delegate?.selectCell(index: selectButton.tag)
            self.delegate?.reloadCollection()
            
        }
        
    }
    
}
