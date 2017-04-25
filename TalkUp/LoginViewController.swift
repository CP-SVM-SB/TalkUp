//
//  LoginViewController.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse
import SwiftGifOrigin
import TextFieldEffects


class LoginViewController: UIViewController {
  

    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet weak var usernameField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var signupButton: UIButton!
    
    var urlArr = [String]()
    var cellIndexArr = [Int]()
    var theme: Theme?
    var userSettings: UserSettings?
    var anonUser = AnonUser()
    
    let flickrClient = Flickr()
    let fakeTopicsArr = ["Donald Trump", "United Airlines", "Coachella", "Kendrick Lamar", "Maxine Waters", "North Korea", "Howard University", "CodePath"]
    

  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.global().async {
        self.getTopicImageUrls()
    }
    

    
    self.passwordField.isSecureTextEntry = true
    self.usernameField.becomeFirstResponder()
    
    self.hideKeyboardWhenTappedAround()
    
    userSettings = setDefaultSettings()
    
    self.backgroundImageView.image = UIImage(named: "water_night_6.jpg")
    self.signupButton.layer.masksToBounds = true
    self.signInButton.layer.cornerRadius = 23
    self.signInButton.backgroundColor = .clear
    self.signInButton.layer.borderWidth = 1
    self.signInButton.layer.borderColor = UIColor.white.cgColor
    
    self.logoImageView.image = UIImage(named: "logo.png")
    

    let placeholderColor = UIColor.lightGray    // placeholder text
    
    self.signupButton.titleLabel?.textColor = .white
    
    
    
    self.usernameField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : placeholderColor])
    self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : placeholderColor])
    
    anonUser.setAnonInfo(themeNum: 0)
    
    userSettings?.profileImage = UIImage(named: anonUser.anonProfilePic)
    userSettings?.username = anonUser.anonUserName
    print("YOUR USERNAME IS:", anonUser.anonUserName)
    print("YOUR PROFILEPIC IS:", anonUser.anonProfilePic)

  }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
  
  @IBAction func onSignIn(_ sender: UIButton) {
    signInButton.alpha = 0.5  // subtle alert to user network call is being made
    
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) {
      (user: PFUser?, error: Error?) -> Void in
      if user != nil {
        print("Successful login!")
        self.performSegue(withIdentifier: "loginToAnimationsSegue", sender: nil)
        
      } else {
        let alert = UIAlertController(title: "Sorry!", message: error?.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(UIAlertAction)in})
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
      }
    }
    signInButton.alpha = 1
  }

// ------------------------ PREPARE FOR SEGUE --------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loginToAnimationsSegue"{
            let animsVC = segue.destination as! AnimationsViewController
            animsVC.userSettings = self.userSettings
            animsVC.urlArr = self.urlArr
            animsVC.cellIndexArr = self.cellIndexArr
        }
        
    }
    
    func setDefaultSettings() -> UserSettings {
        
        var notificationsOn = Bool()
        var encryptMessages = Bool()
        var enableVoiceMessaging = Bool()
        var fontSize = Int()
        var username = String()
        var profileImage = UIImage()
        
        notificationsOn = false
        encryptMessages = false
        enableVoiceMessaging = false
        fontSize = 15
        username = "empty"
        profileImage = UIImage(named: "Selected.png")!
        
        return UserSettings.init(notificationsOn: notificationsOn, encryptMessages: encryptMessages, enableVM: enableVoiceMessaging, fontSize: fontSize, theme: setDefaultTheme(), username: username, profileImage: profileImage)
    }

    func setDefaultTheme() -> Theme {
        
        var primaryColor = UIColor()
        var secondaryColor = UIColor()
        var tertiaryColor = UIColor()
        var quaternaryColor = UIColor()
        var quinaryColor = UIColor()
        var characterType = String()
        var backgroundImage = UIImage()
        var font = String()
        
        
        primaryColor = hexStringToUIColor(hex: "F0EFF5")
        secondaryColor = hexStringToUIColor(hex: "ffffff")
        tertiaryColor =  hexStringToUIColor(hex: "ffffff")
        quaternaryColor = hexStringToUIColor(hex: "000000")
        quinaryColor = hexStringToUIColor(hex: "000000")
        characterType = "Robots"
        backgroundImage = UIImage(named: "HomeImage.png")!
        font = "gillSans.ttf"

        
        return Theme.init(primaryColor: primaryColor, secondaryColor: secondaryColor, tertiaryColor: tertiaryColor, quaternaryColor: quaternaryColor, quinaryColor: quinaryColor, characterType: characterType, backgroundImage: backgroundImage, font: font)
    }
    
    
    func getTopicImageUrls(){
       
        for i in 0...fakeTopicsArr.count-1 {
            let tag = self.fakeTopicsArr[i].replacingOccurrences(of: " ", with: "+")
            flickrClient.requestPhoto(tag: tag, success: { (string: String) in
                self.cellIndexArr.append(i)
                self.urlArr.append(string)
            }) { (error: Error) in
                print("Error getting urls")
            }
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

    
  
}


extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}
