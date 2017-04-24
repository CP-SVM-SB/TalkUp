//
//  AnimationsViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 4/9/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import RevealingSplashView
import SwiftGifOrigin

class AnimationsViewController: UIViewController {
  
  private var revealingLoaded = false
  
    var revealingSplashView = RevealingSplashView(iconImage: UIImage.gif(name: "loading1")! ,iconInitialSize: CGSize(width: 400, height: 400), backgroundColor: UIColor.black)
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
    
    revealingSplashView = RevealingSplashView(iconImage: UIImage.gif(name: "loading1")! ,iconInitialSize: CGSize(width: 500, height: 500), backgroundColor: hexStringToUIColor(hex: "efedef"))
    self.view.addSubview(revealingSplashView)
    
    revealingSplashView.duration = 2.0
    revealingSplashView.animationType = SplashAnimationType.heartBeat
  }
  
  
  override func viewDidLayoutSubviews() {
    revealingSplashView.startAnimation(){
      self.revealingLoaded = true
      self.setNeedsStatusBarAppearanceUpdate()
    }
    
    perform(#selector(AnimationsViewController.segueToTopics), with: nil, afterDelay: 3.2)
  }
  
  
    func loadImageData(){
        
        for i in 0...urlArr.count-1 {
            let data = try! Data(contentsOf: URL(string: urlArr[i])!)
            dataArr.append(data)
        }
        
    }
 
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
