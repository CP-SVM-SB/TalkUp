//
//  ParseClient.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/26/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse

class ParseClient: NSObject {
    
    func setupQueue () {
        var queue = PFObject(className: "queue")
        queue["list"] = [4, 3]
        
        queue.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("list setup")
            }
            else {
                print("error setting queue")
            }
        }
    }
    
    func queueChatWithId (id: Int, onSuccess: @escaping () -> ()) {
        var query = PFQuery(className: "queue")
        
        query.getObjectInBackground(withId: "kOnNLRhWPG") { (queue: PFObject?, error: Error?) in
            if let queue = queue {
                var list = queue["list"] as! Array<Any>
                print(list)
                
                list.append(id)
                queue["list"] = list
                
                queue.saveInBackground(block: { (success: Bool, error: Error?) in
                    print("Queue updated")
                    onSuccess()
                })
            }
        }
        
    }
    
    func getChatCount (onSuccess: @escaping (Int) -> ()) -> (){
        var query = PFQuery(className: "chatCount")
        
        var count = -999
        
        query.getObjectInBackground(withId: "oSxYliZ7a6") { (chat: PFObject?, error: Error?) in
            if let chat = chat {
                count = chat["count"] as! Int
            }
            onSuccess(count)
        }
        
        
    }
    
    func updateChatCount (){
        var query = PFQuery(className: "chatCount")
        
        query.getObjectInBackground(withId: "oSxYliZ7a6") { (chat: PFObject?, error: Error?) in
            if chat != nil {
                let currentValue = chat?["count"] as! Int
                let newValue = currentValue + 1
                chat?["count"] = newValue
                chat?.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("chat count updated from \(currentValue) to \(newValue)")
                    }
                })
            }
        }
    }
 
    
    
    func setChatCount () {
        var chat = PFObject(className: "chatCount")
        chat["key"] = "this"
        chat["count"] = 0
        
        chat.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("Chat count set")
            }
            else {
                print("error setting chat count")
            }
        }
    }
    
    
    func createNewChat(onSuccess: @escaping (Int) -> ()) {
        var count = getChatCount { (count: Int) in
            if count != -999 {
                let id = count + 1
                var chat = PFObject(className: "chat\(id)")
                chat["count"] = id
                chat["memberCount"] = 0
                chat["open"] = 0
                chat.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("New Chat created")
                        onSuccess(id)
                    }
                    else {
                        print("error creating chat")
                    }
                })
                self.updateChatCount()
            }
        }
        
    }
    
    func createNewChatWithId(id: Int, onSuccess: @escaping () -> ()) {
        
        var chat = PFObject(className: "chat\(id)")
        chat["count"] = id
        chat["memberCount"] = 0
        chat["open"] = 0
        //chat["activeMembers"] = ["nil"]
        chat["topic"] = "nil"
        chat.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                print("New Chat created")
                onSuccess()
            }
            else {
                print("error creating chat")
            }
        })
        self.updateChatCount()
        
    }
    
    func getChatWithId(id: Int) {
        
    }
    
    func addLocationToChatWithId(location: Location, id: Int, onSuccess: @escaping () -> ()) {
        let query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo{
                chatInfo["longitude"] = location.longitude
                chatInfo["latitude"] = location.latitude
                
                chatInfo.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("location added to chat")
                        onSuccess()
                    }
                })
            }
        }
    }
    
    func makeOpenChatWithId(id: Int, onSuccess: @escaping() -> ()) {
        let query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo{
                chatInfo["open"] = 1
                
                chatInfo.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("Chat is now open for others nearby to join")
                        onSuccess()
                    }
                })
            }
        }
    }
    
    func closeChatWithId(id: Int, onSuccess: @escaping() -> ()) {
        let query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo{
                chatInfo["open"] = 0
                
                chatInfo.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("Chat is now closed and private")
                        onSuccess()
                    }
                })
            }
        }
    }
    
    func getInfoForChatWithId(id: Int, onSuccess: @escaping (ChatRoom) -> ()) {
        let query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo {
                let room = ChatRoom()
                room.count = chatInfo["count"] as! Int
                let longitude = chatInfo["longitude"] as! String
                if longitude == "nil" {
                    room.location?.longitude = nil
                }
                else {
                    room.location?.longitude = Double(longitude)
                }
                let latitude = chatInfo["latitude"] as! String
                if latitude == "nil" {
                    room.location?.latitude = nil
                }
                else {
                    room.location?.latitude = Double(latitude)
                }
                room.memberCount = chatInfo["memberCount"] as! Int
                room.open = chatInfo["open"] as! Int
                room.topic = chatInfo["topic"] as! String
                
            }
            
        }
    }
        
    
    func createAndJoinChatWithId(id: Int, onSuccess: @escaping (ChatRoom) -> ()) {
        let room = ChatRoom()
        room.count = id
        room.memberCount = 1
        room.open = 0
        room.topic = "nil"
        
        let chat = PFObject(className: "chat\(id)")
        chat["longitude"] = "nil"
        chat["latitude"] = "nil"
        chat["count"] = id
        chat["memberCount"] = 1
        chat["open"] = 0
        //chat["activeMembers"] = ["nil"]
        chat["topic"] = "nil"
        chat.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                print("New Chat created")
                onSuccess(room)
            }
            else {
                print("error creating chat")
            }
        })
        self.updateChatCount()
    }
    
    func joinChatWithId(id: Int, onSuccess: @escaping (ChatRoom) -> ()) {
        var chat = ChatRoom()
        var query = PFQuery(className: "chat\(id)")
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo{
                
                chat.count = chatInfo["count"] as! Int
                chat.memberCount = chatInfo["memberCount"] as! Int
                //chat.members = chatInfo["activeMembers"] as! [String]
                chat.open = chatInfo["open"] as! Int
                /*
                let topic = chatInfo["topic"] as! String
                if topic == "nil" {
                    chat.topic = nil
                }
                else {
                    chat.topic = topic
                }*/
                let user = PFUser.current()?.username!
                chat.members.append(user!)
                chat.memberCount = chat.memberCount+1
                
                chatInfo["memberCount"] = chat.memberCount
                //chatInfo["members"] = chat.members
                
                chatInfo.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("chat created")
                        print(chat)
                        onSuccess(chat)
                    }
                })
            }
        }
    }
    
    func exitChatWithId(id: Int, onSuccess: @escaping () -> ()) {
        var query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chat: PFObject?, error: Error?) in
            if let chat = chat {
                var memberCount = chat["memberCount"] as! Int
                memberCount = memberCount - 1
                
                chat["memberCount"] = memberCount
                
                chat.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("user has left the chat")
                        onSuccess()
                    }
                })
            }
        }
    }
    
    func sendMessageToChatWithId(message: Message, id: Int, onSuccess: @escaping () -> (), onFailure: @escaping (Error) -> ()) {
        let messageSender = PFObject(className: "chat\(id)")
        messageSender["text"] = message.text
        messageSender["from"] = message.from
        //messageSender["timeStamp"] = message.timeStamp
        
        messageSender.saveInBackground { (success: Bool, error: Error?) in
            if let error = error {
                onFailure(error)
            }
            else {
                
                onSuccess()
            }
        }
    }
    
    func getMessagesFromChatWithId(id: Int, onSuccess: @escaping ([Message]) -> (), onFailure: @escaping (Error) -> ()) {
        var messages: [Message] = []
        
        var query = PFQuery(className: "chat\(id)")
        query.order(byAscending: "createdAt")
        var flag = false
        
        query.findObjectsInBackground { (response: [PFObject]?, error:Error?) in
            if let error = error {
                onFailure(error)
            }
            else {
                if let response = response {
                    for eachMessage in response {
                        if flag == true {
                            let message = Message()
                            message.from = eachMessage["from"] as! String?
                            message.text = eachMessage["text"] as! String?
                            message.timeStamp = " "
                            //eachMessage["_created_at"] as! String?
                            
                            messages.append(message)
                        }
                        else {
                            flag = true
                        }
                    }
                    
                }
                
                onSuccess(messages)
            }
        }

    }
    
    
    
    func sendMessage(message: Message, onSuccess: @escaping () -> (), onFailure: @escaping (Error) -> ()) {
        
        let messageSender = PFObject(className: "ChatMessage")
        messageSender["text"] = message.text
        messageSender["from"] = message.from
        //messageSender["timeStamp"] = message.timeStamp
        
        messageSender.saveInBackground { (success: Bool, error: Error?) in
            if let error = error {
                onFailure(error)
            }
            else {
                
                onSuccess()
            }
        }
    }
    
    func getMessages(onSuccess: @escaping ([Message]) -> (), onFailure: @escaping (Error) -> ()) {
        var messages: [Message] = []
        
        var query = PFQuery(className: "ChatMessage")
        query.order(byAscending: "createdAt")
        
        query.findObjectsInBackground { (response: [PFObject]?, error:Error?) in
            if let error = error {
                onFailure(error)
            }
            else {
                if let response = response {
                    for eachMessage in response {
                        let message = Message()
                        message.from = eachMessage["from"] as! String?
                        message.text = eachMessage["text"] as! String?
                        message.timeStamp = " "
                            //eachMessage["_created_at"] as! String?
                        
                        messages.append(message)
                    }
                    
                }
                
                onSuccess(messages)
            }
        }
    }
    
    func listOfOpenChats() -> () {
        
    }
    
    
    
    
    func findChat(onSuccess: @escaping (Int, Bool) -> ()) { // returns the id for the next free chat and a bool that is true if the chat exists already and false if not
        // Check if the last chat is full
        getChatCount { (id: Int) in
            var query = PFQuery(className: "chat\(id)")
            query.getFirstObjectInBackground(block: { (chatInfo: PFObject?, error: Error?) in
                if let chatInfo = chatInfo {
                    let numberOfMembers = chatInfo["memberCount"] as! Int
                    let open = chatInfo["open"] as! Int
                    if open == 1 /*and the chat is within 50 miles*/ {
                        
                    }
                    else {
                        if numberOfMembers < 2{
                            onSuccess(id, true)
                        }
                        else {
                            onSuccess(id+1, false)
                        }
                    }
                }
            })
            
        }
        // If it is full create a new chat
        // if it is not full then add the member
        // If i
    }
}
