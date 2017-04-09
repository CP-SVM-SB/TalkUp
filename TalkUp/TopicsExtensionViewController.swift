//
//  TopicsExtensionViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 4/8/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

extension TopicsViewController: UIViewControllerPreviewingDelegate {
  
  // PEEK
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    
    guard let indexPath = tableView.indexPathForRow(at: location),
      let cell = tableView.cellForRow(at: indexPath) else {return nil}
    
    guard let previewChatsVC = storyboard?.instantiateViewController(withIdentifier: "PreviewChatsVC") as? PreviewChatsViewController else {return nil}
    
    
    // data
    let key = self.keywords[indexPath.row]
    previewChats = self.keywordDict[key]
    
    previewChatsVC.topic = key
    previewChatsVC.chatsWithKeyWord = previewChats
    
    
    // VC settings
    previewChatsVC.preferredContentSize = CGSize(width: 0, height: 450)
    previewingContext.sourceRect = cell.frame
    
    return previewChatsVC
    
  }
  
  
  
  // POP
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    
    if let ChatsPopVC = storyboard?.instantiateViewController(withIdentifier: "ChatsPopVC") as? ChatsPopViewController {
      
      ChatsPopVC.chatsWithKeyWord = previewChats
      
      show(ChatsPopVC, sender: nil)
    }
    
  }
  
}
