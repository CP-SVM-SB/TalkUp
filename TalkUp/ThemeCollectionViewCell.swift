//
//  ThemeCollectionViewCell.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: UICollectionViewCell {
    
   
    
    @IBOutlet weak var themeImageView: UIImageView!
    
    @IBOutlet weak var themeButton: UIButton!
    
    
    @IBAction func didTapCell(_ sender: UIButton) {
        
        print("cell tapped")
        
        if themeButton.isSelected == true {
            themeButton.isSelected = false
        }else{
            themeButton.isSelected = true
        }
    
    
    }
    
    
}
