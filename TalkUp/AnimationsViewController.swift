//
//  AnimationsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 4/9/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import RevealingSplashView

class AnimationsViewController: UIViewController {
  
  private var revealingLoaded = false
  let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "animationChatIcon")!,iconInitialSize: CGSize(width: 30, height: 30), backgroundColor: UIColor.init(red: 29, green: 143, blue: 241, alpha: 1))
  
  
  override var shouldAutorotate: Bool {
    return revealingLoaded
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(revealingSplashView)
    revealingSplashView.duration = 2.0
    
    revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
  }
  
  
  override func viewDidLayoutSubviews() {
    revealingSplashView.startAnimation(){
      self.revealingLoaded = true
      self.setNeedsStatusBarAppearanceUpdate()
    }
    
    perform(#selector(AnimationsViewController.segueToTopics), with: nil, afterDelay: 2.8)
  }
  
  
  func segueToTopics() {
    self.performSegue(withIdentifier: "animationsToTopicsSegue", sender: self)
  }
  
}
