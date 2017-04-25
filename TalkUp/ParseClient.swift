//
//  ParseClient.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/26/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class ParseClient: NSObject {
    
    func findCloseByChat (userLocation: Location, onSuccess: @escaping (Int) -> (), onFailure: @escaping () -> ()) {
        
        let uLocation = CLLocation(latitude: userLocation.latitude!, longitude: userLocation.longitude!)
        
        let query = PFQuery(className: "queue")
        
        query.getFirstObjectInBackground { (queue: PFObject?, error: Error?) in
            if let queue = queue {
                var list = queue["list"] as! Array<Int>
                var longitude = queue["longitude"] as! Array<Double>
                var latitude = queue["latitude"] as! Array<Double>
                
                var i = 0
                
                while i < list.count {
                    let chatLocation = CLLocation(latitude: latitude[i], longitude: longitude[i])
                    let distanceInMeters = uLocation.distance(from: chatLocation)
                    
                    if distanceInMeters < 80450 {
                        onSuccess(list[i])
                    }
                    
                    i = i + 1
                    
                }
                
                onFailure()
            }
        }
    }
    
    func setupQueue () {
        let queue = PFObject(className: "queue")
        queue["list"] = [1]
        queue["longitude"] = [232.22]
        queue["latitude"] = [232.22]
        
        queue.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("list setup")
            }
            else {
                print("error setting queue")
            }
        }
    }
    
    func queueChatWithId (id: Int, location: Location, onSuccess: @escaping () -> ()) {
        let query = PFQuery(className: "queue")
        var flag = true
        
        query.getFirstObjectInBackground { (queue: PFObject?, error: Error?) in
            if let queue = queue {
                var list = queue["list"] as! Array<Int>
                print(list)
                var longitude = queue["longitude"] as! Array<Double>
                var latitude = queue["latitude"] as! Array<Double>
                
                for num in list {
                    if num == id {
                        flag = false
                    }
                }
                
                if flag == true {
                    list.append(id)
                    longitude.append(location.longitude!)
                    latitude.append(location.latitude!)
                    
                    queue["list"] = list
                    queue["longitude"] = longitude
                    queue["latitude"] = latitude
                    
                    queue.saveInBackground(block: { (success: Bool, error: Error?) in
                        onSuccess()
                    })
                }
                else {
                    print("The chat is already in the queue")
                }
                
                
            }
        }
    }
    
    func dequeueChatWithId (id: Int, onSuccess: @escaping () -> ()) {
        let query = PFQuery(className: "queue")
        
        
        
        query.getFirstObjectInBackground { (queue: PFObject?, error: Error?) in
            if let queue = queue {
                var list = queue["list"] as! Array<Int>
                print(list)
                var longitude = queue["longitude"] as! Array<Double>
                var latitude = queue["latitude"] as! Array<Double>
                
                var index = -999
                
                var i = 0
                while i < list.count {
                    if list[i] == id {
                        index = i
                        i = list.count + 1
                    }
                    i = i + 1
                }
                
                if index != -999 {
                    list.remove(at: index)
                    longitude.remove(at: index)
                    latitude.remove(at: index)
                }
                
                queue["list"] = list
                queue["longitude"] = longitude
                queue["latitude"] = latitude
                
                queue.saveInBackground(block: { (success: Bool, error: Error?) in
                    onSuccess()
                })
            }
        }
    }
    
    func getChatCount (onSuccess: @escaping (Int) -> ()) -> (){
        let query = PFQuery(className: "chatCount")
        
        var count = -999
        
        query.getObjectInBackground(withId: "oSxYliZ7a6") { (chat: PFObject?, error: Error?) in
            if let chat = chat {
                count = chat["count"] as! Int
            }
            onSuccess(count)
        }
        
        
    }
    
    func updateChatCount (){
        let query = PFQuery(className: "chatCount")
        
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
        let chat = PFObject(className: "chatCount")
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
        let count = getChatCount { (count: Int) in
            if count != -999 {
                let id = count + 1
                let chat = PFObject(className: "chat\(id)")
                chat["count"] = id
                chat["memberCount"] = 0
                chat["open"] = 0
                chat["topic"] = "nil"
                chat["longitude"] = "nil"
                chat["latitude"] = "nil"
                chat["activity"] = []
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
        
        let chat = PFObject(className: "chat\(id)")
        chat["count"] = id
        chat["memberCount"] = 0
        chat["open"] = 0
        chat["activeMembers"] = [PFUser.current()?.username]
        chat["topic"] = "nil"
        chat["longitude"] = "nil"
        chat["latitude"] = "nil"
        chat["activity"] = [1]
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
    
    func addLocationToChatWithId(location: Location, id: Int, onSuccess: @escaping () -> ()) {
        let query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo{
                chatInfo["longitude"] = String(describing: location.longitude)
                chatInfo["latitude"] = String(describing: location.latitude)
                
                chatInfo.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("location added to chat")
                        onSuccess()
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                })
            }
        }
    }
    
    func openChatWithId(id: Int, location: Location, onSuccess: @escaping() -> ()) {
        let query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo{
                chatInfo["open"] = 1
                chatInfo["longitude"] = String(describing: location.longitude)
                chatInfo["latitude"] = String(describing: location.latitude)
                
                chatInfo.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("Chat is now open for others nearby to join")
                        onSuccess()
                    }
                    if let error = error {
                        print(error.localizedDescription)
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
                room.topic = chatInfo["topic"] as? String
                
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
        chat["activeMembers"] = [PFUser.current()?.username!]
        chat["topic"] = "nil"
        chat["activity"] = [1]
        chat.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                print("New Chat created and joined with id \(id)")
                onSuccess(room)
            }
            else {
                print("error creating chat")
            }
        })
        self.updateChatCount()
    }
    
    func joinChatWithId(id: Int, onSuccess: @escaping (ChatRoom) -> ()) {
        let chat = ChatRoom()
        let query = PFQuery(className: "chat\(id)")
        query.getFirstObjectInBackground { (chatInfo: PFObject?, error: Error?) in
            
            if let chatInfo = chatInfo{
                
                //chat.count = chatInfo["count"] as! Int
                //chat.memberCount = chatInfo["memberCount"] as! Int
                //chat.members = chatInfo["activeMembers"] as! [String]
                //chat.open = chatInfo["open"] as! Int
                //chat.activity = chatInfo["activity"] as! [Int]
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
                chat.activity.append(1)
                
                chatInfo["memberCount"] = chat.memberCount
                chatInfo["activity"] = chat.activity
                chatInfo["activeMembers"] = chat.members
                //chatInfo["members"] = chat.members
                
                chatInfo.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("chat chat with id \(chat.count)")
                        print(chat)
                        onSuccess(chat)
                    }
                    print("error saving chat after joining")
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
                var members = chat["activeMembers"] as! [String]
                var activity = chat["activity"] as! [Int]
                
                var i = 0
                
                while i < members.count {
                    if members[i] == PFUser.current()?.username! {
                        members.remove(at: i)
                        activity.remove(at: i)
                    }
                    i = i + 1
                }
                
                chat["activeMembers"] = members
                chat["activity"] = activity
                
                
                chat.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("user has left the chat")
                        onSuccess()
                    }
                })
            }
        }
    }
    
    func changeToActive(id: Int) {
        var query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chat: PFObject?, error: Error?) in
            if let chat = chat {
                var members = chat["activeMembers"] as! [String]
                var activity = chat["activity"] as! [Int]
                var i = 0
                while i < members.count {
                    if members[i] == PFUser.current()?.username! {
                        activity.remove(at: i)
                        activity.insert(1, at: i)
                        
                    }
                    i = i + 1
                }
                chat["activity"] = activity
                
                chat.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("user is now active")
                    }
                })
            }
        }
    }
    
    func changeToInactive(id: Int) {
        var query = PFQuery(className: "chat\(id)")
        
        query.getFirstObjectInBackground { (chat: PFObject?, error: Error?) in
            if let chat = chat {
                var members = chat["activeMembers"] as! [String]
                var activity = chat["activity"] as! [Int]
                var i = 0
                while i < members.count {
                    if members[i] == PFUser.current()?.username! {
                        activity.remove(at: i)
                        activity.insert(0, at: i)
                        
                    }
                    i = i + 1
                }
                chat["activity"] = activity
                
                chat.saveInBackground(block: { (success: Bool, error: Error?) in
                    if success {
                        print("user is now active")
                    }
                })
            }
        }
    }
    
    func getDataForChatWithId(id: Int, onSuccess: @escaping ([Message], Bool, [Int]) -> ()) {
        var messages: [Message] = []
        
        let query = PFQuery(className: "chat\(id)")
        query.order(byAscending: "createdAt")
        var flag = false
        var open = false
        var activity: [Int] = []
        
        query.findObjectsInBackground { (response: [PFObject]?, error:Error?) in
            if let error = error {
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
                            
                            let isOpen = eachMessage["open"] as! Int
                            if isOpen == 1 {
                                open = true
                            }
                            else {
                                open = false
                            }
                            activity = eachMessage["activity"] as! [Int]
                            flag = true
                        }
                    }
                    
                }
                
                onSuccess(messages, open, activity)
            }
        }
    }

    
    func cleanupChatWithId(id: Int, onSuccess: @escaping () -> ()) {
        var query = PFQuery(className: "chat\(id)")
        query.order(byAscending: "createdAt")

        var flag = false
        
        query.findObjectsInBackground { (response: [PFObject]?, error:Error?) in
            if let error = error {
                print("error cleaning up chat!")
            }
            else {
                var i = 1
                
                while i < (response?.count)! {
                    response?[i].deleteEventually()
                    
                    i = i + 1
                }
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
    
    func sendInitialMessageToChatWithId(id: Int, onSuccess: @escaping () -> (), onFailure: @escaping (Error) -> ()) {
        let messageSender = PFObject(className: "chat\(id)")
        messageSender["text"] = "Let's Talk Up!"
        messageSender["from"] = "admin"
        
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
        
        let query = PFQuery(className: "chat\(id)")
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
        messageSender["image"] = message.imageTitle
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
                        message.imageTitle = eachMessage["image"] as! String?
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
                  var numberOfMembers = 0
                  var open = 0
                  if let noMembers = chatInfo["memberCount"] as? Int {
                     numberOfMembers = noMembers
                  }
                  
                  if let openStatus = chatInfo["open"] as? Int {
                    open = openStatus
                  }
                  
                    if numberOfMembers < 2{
                        onSuccess(id, true)
                    }
                    else {
                        onSuccess(id+1, false)
                    }
                    
                }
            })
            
        }
        // If it is full create a new chat
        // if it is not full then add the member
        // If i
    }
}
