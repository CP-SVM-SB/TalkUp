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
    
    
    var delegate: SettingsTableViewController?
    
    // CANT BELIEVE I GOT THIS WORKING NOW BUT IT WOOOOOORRKSSS: YOU CAN NOW SELECT ONLY 1 CELL WHICH UPDATES LOCAL THEME OBJECT - SVM
    @IBAction func didTapCell(_ sender: UIButton) {
        
        if themeButton.isSelected == false {
            
            self.delegate?.resetSelection()
            self.delegate?.selectCell(index: themeButton.tag)
            self.delegate?.loadNewSelection()
            Theme.init(choosenTheme: themeButton.tag)
    
        }
        
    }
    
    
}
