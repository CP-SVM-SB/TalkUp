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
}
