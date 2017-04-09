//
//  Themes.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//
//
// There are 5 Different Themes
// A Theme Object Contains:
//  - Primary Color
//  - Secondary Color
//  - Tertiary Color
//  - Chat Background Image
//  - Font

import Foundation
import UIKit

class Theme {
   
    init(choosenTheme: Int){
        switch (choosenTheme){
            
        case 0:
            print("theme1")
        case 1:
            print("theme2")
        case 2:
            print("theme3")
        case 3:
            print("theme4")
        case 4:
            print("theme5")
        default:
            print("no theme")
            
        }
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
