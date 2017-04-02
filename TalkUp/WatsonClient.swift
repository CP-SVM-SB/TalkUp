//
//  KeywordClient.swift
//  TalkUp
//
//  Created by Tunscopi on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import AFNetworking


class WatsonClient: NSObject {
  // Watson Developer Cloud, Alchemy Language API
  let baseUrl = "https://gateway-a.watsonplatform.net/calls/text/TextGetRankedKeywords"
  let apiKey = "a2ee7347bc4e404e4edf850025ae6e619eed7dc9"
  
  var keyWords = [String]()
  var encodedStr: String?
  var keyword: String?
  
  
  
  func performKeywordSearch(textBody: String, success: @escaping ([String])->(), failure: @escaping (Error)->()) {
    self.encodedStr = textBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)  // text needs to be UTF-8
    
    let url = URL(string: baseUrl + "?apikey=\(apiKey)&outputMode=json&text=\(encodedStr!)")
    let request = URLRequest(url: url!)
    let session = URLSession(
      configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
    )
    
    let task = session.dataTask(with: request) { (data, response, error) in
      if let data = data {
        if let watsonResponse = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
          let returnedKeyWords = self.keywordsArray(dict: watsonResponse)
          success(returnedKeyWords)
          
        }
      }
    }
    task.resume()
  }
  
  
  
  func keywordsArray(dict: NSDictionary) -> [String] {
    
    if let status = dict["status"] as? String {
      if status == "OK" {
        print (dict["usage"] ?? "Well, no T&C!")
        
        if let keyArr = dict["keywords"] as? NSArray {
          for (_, keyDict) in keyArr.enumerated() {
            if let keyDict = keyDict as? NSDictionary {
              keyword = keyDict["text"] as? String
              self.keyWords.append(keyword!)
            }
          }
        }
        
      }
    }
   return self.keyWords
  }
  
}






