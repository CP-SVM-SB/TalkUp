//
//  Message.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class Message: NSObject {
    var text: String?
    var from: String?
    var imageTitle: String?
    var timeStamp: String?
    
    override init() {
        text = nil
        from = nil
        timeStamp = nil
        imageTitle = nil
    }
}
