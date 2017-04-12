//
//  ChatRoom.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class ChatRoom: NSObject {
    
    var count: Int
    var messages: [Message]
    var members: [String]
    var memberCount: Int
    var open: Int
    var location: Location?
    var topic: String?
    var activity: [Int]
    
    override init() {
        count = 0
        messages = []
        members = []
        memberCount = 0
        open = 0
        location = Location()
        topic = nil
        activity = []
    }
    
    //
}
