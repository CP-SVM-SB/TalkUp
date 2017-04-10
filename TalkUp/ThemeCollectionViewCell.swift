//
//  ThemeCollectionViewCell.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Foundation



class ThemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeButton: UIButton!
    
    var delegate: SettingsTableViewController?
    
    var didSelect = Bool()
    var primaryColor = UIColor()
    var secondaryColor = UIColor()
    var tertiaryColor = UIColor()
    var quaternaryColor = UIColor()
    var characterType = String()
    var backgroundImage = UIImage()
    var font = String()
    var theme: Theme?
    
    
    // CAN'T BELIEVE I GOT THIS WORKING NOW BUT IT WOOOOOORRKSSS: YOU CAN NOW SELECT A THEME WHICH UPDATES LOCAL THEME OBJECT - SVM
    @IBAction func didTapCell(_ sender: UIButton) {
        
        if themeButton.isSelected == false {
            
            self.delegate?.resetSelection()
            self.delegate?.selectCell(index: themeButton.tag)
            self.delegate?.loadNewSelection()
            
            theme = setTheme(choosenTheme: themeButton.tag)
            
            self.delegate?.theme = theme
            self.updateCellView()
            self.delegate?.reloadView()
            
            
        }
    
    }
    
    
    func updateCellView(){
        self.superview?.superview?.backgroundColor = theme?.secondaryColor
        self.superview?.backgroundColor = theme?.secondaryColor
    }
    
    func setTheme(choosenTheme: Int) -> Theme {
        switch (choosenTheme){
        case 0:                 //TESTING FUNCTIONALITY
            primaryColor = hexStringToUIColor(hex: "F0EFF5")
            secondaryColor = hexStringToUIColor(hex: "ffffff")
            tertiaryColor =  hexStringToUIColor(hex: "ffffff")
            quaternaryColor = hexStringToUIColor(hex: "000000")
            characterType = "Robots"
            backgroundImage = UIImage(named: "HomeImage.png")!
            font = "gillSans.ttf"
            
        case 1:
            primaryColor = hexStringToUIColor(hex: "6897BB")
            secondaryColor = hexStringToUIColor(hex: "b8b8b8")
            tertiaryColor =  hexStringToUIColor(hex: "ffffff")
            quaternaryColor = hexStringToUIColor(hex: "000000")
            characterType = "Robots"
            backgroundImage = UIImage(named: "HomeImage.png")!
            font = "gillSans.ttf"
        case 2:
            primaryColor = hexStringToUIColor(hex: "087f98")
            secondaryColor = hexStringToUIColor(hex: "e0e0e0")
            tertiaryColor =  hexStringToUIColor(hex: "ffffff")
            quaternaryColor = hexStringToUIColor(hex: "000000")
            characterType = "Robots"
            backgroundImage = UIImage(named: "HomeImage.png")!
            font = "gillSans.ttf"
        case 3:
            primaryColor = hexStringToUIColor(hex: "334559")
            secondaryColor = hexStringToUIColor(hex: "d3d3d3")
            tertiaryColor =  hexStringToUIColor(hex: "ffffff")
            quaternaryColor = hexStringToUIColor(hex: "000000")
            characterType = "Robots"
            backgroundImage = UIImage(named: "HomeImage.png")!
            font = "gillSans.ttf"
        case 4:
            primaryColor = hexStringToUIColor(hex: "8ee5ee")
            secondaryColor = hexStringToUIColor(hex: "a2b5cd")
            tertiaryColor =  hexStringToUIColor(hex: "ffffff")
            quaternaryColor = hexStringToUIColor(hex: "000000")
            characterType = "Robots"
            backgroundImage = UIImage(named: "HomeImage.png")!
            font = "gillSans.ttf"
        default:
            print("no theme")
        }
        
        return Theme.init(primaryColor: primaryColor, secondaryColor: secondaryColor, tertiaryColor: tertiaryColor, quaternaryColor: quaternaryColor, characterType: characterType, backgroundImage: backgroundImage, font: font)
        
        
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    
}
