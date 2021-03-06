//
//  AppDelegate.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var Client = ParseClient()
    var chat = 0
    
    func applicationDidTimout(notification: NSNotification) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "chatVC") as! ChatRoomViewController
        vc.userInactive()
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.applicationDidTimout), name: NSNotification.Name(rawValue: TimerUIApplication.ApplicationDidTimoutNotification), object: nil)
      
        Parse.initialize(
        with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
          configuration.applicationId = "talkupapp"
          configuration.clientKey = "svmcbao"
          configuration.server = "https://talkupapp.herokuapp.com/parse"
        })
      
        )
      
      return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //To retrieve from the key
        let userDefaults = Foundation.UserDefaults.standard
        let value  = userDefaults.string(forKey: "chatId")
        if let value = value {
            print("Chat now Inactive. Chat ID: \(value) ")
            ParseClient().changeToInactive(id: Int(value)!)
            
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //To retrieve from the key
        let userDefaults = Foundation.UserDefaults.standard
        let value  = userDefaults.string(forKey: "chatId")
        if let value = value {
            print("Chat now Inactive. Chat ID: \(value) ")
            ParseClient().changeToInactive(id: Int(value)!)
            
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //To retrieve from the key
        let userDefaults = Foundation.UserDefaults.standard
        let value  = userDefaults.string(forKey: "chatId")
        if let value = value {
            print("Chat now Active. Chat ID: \(value) ")
            ParseClient().changeToActive(id: Int(value)!)
            
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {

        //To retrieve from the key
        let userDefaults = Foundation.UserDefaults.standard
        let value  = userDefaults.string(forKey: "chatId")
        if let value = value {
            print("Exitting chat. Chat ID: \(value) ")
            ParseClient().exitChatWithId(id: Int(value)!, onSuccess: {
                
            })

        }
        

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

