//
//  Themes.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//
//
//  There are 5 Different Themes
//  A Theme Object Contains:
//  - Name
//  - Primary Color
//  - Secondary Color
//  - Tertiary Color
//  - Quaternary Color
//  - Quinary Color
//  - Character Type (robots, animals, planets, fruits, etc)
//  - Chat Background Image
//  - Font
//

import Foundation
import UIKit


class Theme: AnyObject {
    
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    var tertiaryColor: UIColor?
    var quaternaryColor: UIColor?
    var quinaryColor: UIColor?
    var characterType: String?
    var backgroundImage: UIImage?
    var font: String?
   
    init(primaryColor: UIColor, secondaryColor: UIColor, tertiaryColor: UIColor, quaternaryColor: UIColor, quinaryColor: UIColor, characterType: String, backgroundImage: UIImage, font: String){
        
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.tertiaryColor = tertiaryColor
        self.quaternaryColor = quaternaryColor
        self.quinaryColor = quinaryColor
        self.characterType = characterType
        self.backgroundImage = backgroundImage
        self.font = font

    }
    
}
