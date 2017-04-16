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
    
    var urlArr = [String]()
    var cellIndexArr = [Int]()
    var dataArr = [Data]()
    var userSettings: UserSettings?
    
  override var shouldAutorotate: Bool {
    return revealingLoaded
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadImageData()
    
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
  
  
    func loadImageData(){
        
        for i in 0...urlArr.count-1 {
            let data = try! Data(contentsOf: URL(string: urlArr[i])!)
            dataArr.append(data)
        }
        
    }
    
    
  func segueToTopics() {
    self.performSegue(withIdentifier: "animationsToTopicsSegue", sender: self)
  }
    
// ------------------------ PREPARE FOR SEGUE --------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navC = segue.destination as! UINavigationController
        let topicsVC = navC.viewControllers.first as! TopicsViewController
        
        if segue.identifier == "animationsToTopicsSegue"{
            topicsVC.userSettings = self.userSettings
            topicsVC.dataArr = self.dataArr
            topicsVC.cellIndexArr = self.cellIndexArr
        }

    }
  
}
