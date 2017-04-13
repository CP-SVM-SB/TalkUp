//
//  GiphyClient.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/12/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

/*
    q - query
    rating - limit results to those rated (y,g, pg, pg-13 or r).
    fmt - (optional) return results in html or json format (useful for viewing responses as GIFs to debug/test)
    example: "http://api.giphy.com/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC"
*/

import Foundation
import UIKit
import AFNetworking

class Giphy: NSObject {
    
    
    let host_path = "https://api.giphy.com/v1/gifs/search"
    let public_beta_key = "&api_key=dc6zaTOxFJmzC"
    
    var q = String()
    
    
    func makeRandomSearchRequest(success: @escaping (NSArray) ->(), failure: @escaping (Error)->()){
        
        q = "?q=raccoon"
        
        let url = URL(string: host_path+q+public_beta_key)
        let session = URLSession(
            configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
        )
        let task = session.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("Error: ", error!)
            } else {
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    let returnedData = response["data"] as! NSArray
                    
                    let images = returnedData.value(forKey: "images") as! NSArray
                    let originalGifs = images.value(forKey: "fixed_height_small") as! NSArray
                    let gifUrls = originalGifs.value(forKey: "url") as! NSArray
                    
                    //print("URLS: ", gifUrls)
                    
                    //looping through all the json objects in the array teams
//                    for i in 0 ..< testData.count{
//                        let image: Int = (testData["fixes"] as! NSString).integerValue
//                        print(image)
//                    }
                    
//                    let image = returnedData.o"image"] as? NSArray
//                    print(image)
                    
                    success(gifUrls)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }
            task.resume()
        
        //return gifUrl
        
    }
    
    
    
}
