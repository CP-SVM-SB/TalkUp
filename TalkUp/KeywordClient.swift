//
//  KeywordClient.swift
//  TalkUp
//
//  Created by Tunscopi on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import AFNetworking


class KeywordClient: NSObject {
  // Using Watson Developer Cloud, Alchemy Language API
  let baseUrl = "https://gateway-a.watsonplatform.net/calls/text/TextGetRankedKeywords"
  let apiKey = "a2ee7347bc4e404e4edf850025ae6e619eed7dc9"
  
  var keyWords: NSDictionary? = nil
  var encodedStr: String?
  
  
  
  func getKeywords(textBody: String) {
    self.encodedStr = textBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    
    let url = URL(string: baseUrl + "?apikey=\(apiKey)&outputMode=json&text=\(encodedStr!)")
    let request = URLRequest(url: url!)
    let session = URLSession(
      configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main
    )
    
    let task = session.dataTask(with: request) { (data, response, error) in
      if let data = data {
        if let keywordsResponse = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
          print(keywordsResponse)
          self.keyWords = keywordsResponse
        }
      }
    }
    task.resume()
  }
  
  
}
