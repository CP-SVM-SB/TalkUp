//
//  GiphyClient.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/12/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

/*
    tag - the GIF tag to limit randomness by
    rating - limit results to those rated (y,g, pg, pg-13 or r).
    fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test)
    example: "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=american+psycho"
*/

import Foundation
import UIKit
import AFNetworking

class Giphy: NSObject {
    
    
    let host_path = "https://api.giphy.com/v1/gifs/random"
    let public_beta_key = "?api_key=dc6zaTOxFJmzC"
    
    var tag = String()
    var gifUrl = String()
    
    
    func makeRandomRequest() -> String {
        
        tag = "&tag=raccoon"
        
        let url = URL(string: host_path+public_beta_key+tag)
        let request = URLRequest(url: url!)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
        )
        
        
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let returnedData = response["data"] as! [String:Any]
                    self.gifUrl = returnedData["image_url"] as! String

                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
        
//        let task = session.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                if let response = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                    let returnedData = response["data"] as! [String:Any]
//                    self.gifUrl = returnedData["image_url"] as! String
//
//                    //print("RESPONSE: ", response)
//                    //print("GIF URL:", gifUrl)
//                    
//                }
//            }
//        }
//        task.resume()
        return gifUrl
        
    }
    
    
    
}
