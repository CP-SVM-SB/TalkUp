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
    let key = self.keywordsArr[indexPath.row]
    previewChats = self.keywordsWithChats[key]
    
    previewChatsVC.topic = key
    previewChatsVC.chatsWithKeyWord = previewChats
    
    // VC settings
    if (previewChats?.count)! == 1 {
      previewChatsVC.preferredContentSize = CGSize(width: 0, height: 110)

    } else if (previewChats?.count)! < 7 {
      previewChatsVC.preferredContentSize = CGSize(width: 0, height: (previewChats?.count)! * 90)
      
    } else {
      previewChatsVC.preferredContentSize = CGSize(width: 0, height: 420)
    }

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
