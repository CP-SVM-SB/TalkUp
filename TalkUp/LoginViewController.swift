//
//  LoginViewController.swift
//  TalkUp
//
//  Created by Shumba Brown on 3/21/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var signInButton: UIButton!
    
    var theme: Theme?
    var userSettings: UserSettings?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.passwordField.isSecureTextEntry = true
    self.usernameField.becomeFirstResponder()
    
    self.hideKeyboardWhenTappedAround()
    
    userSettings = setDefaultSettings()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "HomeImage.png")!)
    
    let placeholderColor = UIColor.lightGray    // placeholder text
    
    
    self.usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : placeholderColor] )
    self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : placeholderColor])
  }
  
  
  @IBAction func onSignIn(_ sender: UIButton) {
    signInButton.alpha = 0.5  // subtle alert to user network call is being made
    
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) {
      (user: PFUser?, error: Error?) -> Void in
      if user != nil {
        print("Successful login!")
        print(self.userSettings)
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
        
        
        primaryColor = UIColor.white
        secondaryColor = UIColor.black
        tertiaryColor = UIColor.gray
        quaternaryColor = UIColor.lightGray
        quinaryColor = UIColor.darkGray
        characterType = "Robots"
        backgroundImage = UIImage(named: "Selected.png")!
        font = "gillSans.ttf"
        
        return Theme.init(primaryColor: primaryColor, secondaryColor: secondaryColor, tertiaryColor: tertiaryColor, quaternaryColor: quaternaryColor, quinaryColor: quinaryColor, characterType: characterType, backgroundImage: backgroundImage, font: font)
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
