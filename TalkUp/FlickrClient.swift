//
//  FlickrClient.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/16/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//
//
// ex. https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4979727aa484867e6893f0579dfa2a04&tags=wwiii&format=json


import Foundation
import AFNetworking
import UIKit


class Flickr: NSObject {
    
    let host_path = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    let api_key = "&api_key=e5eb7fea03257059c5129ce8c869d840"
    let format = "&format=json&nojsoncallback=1"
    let secret = "08acbf323c8cb3bd" // not needed?
    let user_id = "149250011@N05" // not needed?
    var tag_start = "&tags="
    //&api_key=4979727aa484867e6893f0579dfa2a04
    //"&api_key=e5eb7fea03257059c5129ce8c869d840"
    func requestPhoto(tag: String, success: @escaping (String) ->(), failure: @escaping (Error)->()){
        
        let url = URL(string: host_path+api_key+tag_start+tag+format)
        let session = URLSession(
            configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
        )
        
        let task = session.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("Error: ", error!)
            } else {
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    let returnedData = response["photos"] as! NSDictionary
                    let photoArr = returnedData.value(forKey: "photo") as! NSArray
                    let photourl = self.convertToUrl(dict: photoArr[1] as! NSDictionary)

                    success(photourl)

                } catch let error as NSError {
                    print(error)
                }
            }
        
        }
        task.resume()
        
    }
    
    
    func convertToUrl(dict: NSDictionary) -> String{
        
        //url format: https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        
        var url = String()
        let host = "https://farm"
        
        let id = dict.value(forKey: "id") as! String
        let secret = dict.value(forKey: "secret") as! String
        let server = dict.value(forKey: "server") as! String
        let farm = dict.value(forKey: "farm") as! Int
        let farmStr = "\(farm)"
        let idStr = "\(id)"
        
        url = String(host+farmStr+".staticflickr.com/"+server+"/"+idStr+"_"+secret+".jpg")
    
        return url
    }

    
    
    
}
