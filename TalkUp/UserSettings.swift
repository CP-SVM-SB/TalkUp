//
//  UserSettings.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/8/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//
//  User Settings Modify:
//  - Notifications
//  - Enable Voice Messaging
//  - Encrypting Messages
//  - Font Size
//  - Theme
//  - Anonymous Randomly Selected User Name
//  - Anonymous Randomly Selected Profile Pic

import Foundation
import UIKit


class UserSettings {
    
    var notificationsOn: Bool?
    var encryptMessages: Bool?
    var enableVoiceMessaging: Bool?
    var fontSize: Int?
    var theme: Theme?
    var username: String?
    var profileImage: UIImage?
    
    
    init(notificationsOn: Bool, encryptMessages: Bool, enableVM: Bool, fontSize: Int, theme: Theme, username: String, profileImage: UIImage) {
        
        self.notificationsOn = notificationsOn
        self.encryptMessages = encryptMessages
        self.enableVoiceMessaging = enableVM
        self.fontSize = fontSize
        self.theme = theme
        self.username = username
        self.profileImage = profileImage
     
    }
    
}
