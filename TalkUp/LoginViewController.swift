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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.passwordField.isSecureTextEntry = true
    
    self.usernameField.becomeFirstResponder()
    self.hideKeyboardWhenTappedAround()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "HomeImage.png")!)
    
    // placeholder text
    let placeholderColor = UIColor.lightGray
    self.usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : placeholderColor] )
    self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : placeholderColor])
  }
  
  
  @IBAction func onSignIn(_ sender: UIButton) {
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) {
      (user: PFUser?, error: Error?) -> Void in
      if user != nil {
        print("Successful login!")
        self.performSegue(withIdentifier: "loginToTopicsSegue", sender: nil)
        
      } else {
        let alert = UIAlertController(title: "Sorry!", message: error?.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(UIAlertAction)in})
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
      }
    }
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
