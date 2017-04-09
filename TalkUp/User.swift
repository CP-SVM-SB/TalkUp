//
//  User.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String?
    var location: Location?
    var active: Bool
    
    override init() {
        username = nil
        location = nil
        active = true
    }
    

}
