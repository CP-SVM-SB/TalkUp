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
  
  override var shouldAutorotate: Bool {
    return revealingLoaded
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let backgroundColour = UIColor.init(red: 29, green: 143, blue: 241, alpha: 1)
      let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "animationChatIcon")!,iconInitialSize: CGSize(width: 45, height: 45), backgroundColor: backgroundColour)
      
      
      self.view.addSubview(revealingSplashView)
      
      revealingSplashView.duration = 0.9
      
      revealingSplashView.iconColor = UIColor.red
      revealingSplashView.useCustomIconColor = false
      
      revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
      
      revealingSplashView.startAnimation(){
        self.revealingLoaded = true
        self.setNeedsStatusBarAppearanceUpdate()
      }
      
      //segueToTopics
      perform(#selector(AnimationsViewController.segueToTopics), with: nil, afterDelay: 1.5)
    }

  
  func segueToTopics() {
    self.performSegue(withIdentifier: "animationsToTopicsSegue", sender: self)
  }

}
