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
        
        let animsVC = segue.destination as! AnimationsViewController
        
        if segue.identifier == "loginToAnimationsSegue"{
            animsVC.userSettings = self.userSettings
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
