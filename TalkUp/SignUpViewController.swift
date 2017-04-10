//
//  SignUpViewController.swift
//  TalkUp
//
//  Created by Tunscopi on 3/25/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.passwordField.isSecureTextEntry = true
    
    // placeholder text
    let placeholderColor = UIColor.lightGray
    self.usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : placeholderColor] )
    self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : placeholderColor])
     self.emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : placeholderColor])

  }
  
  @IBAction func onRegister(_ sender: UIButton) {
    let newUser = PFUser()
    newUser.username = usernameField.text
    newUser.password = passwordField.text
    newUser.email = emailField.text
    
    newUser.signUpInBackground { (success: Bool, error: Error?) in
      if success {
        self.performSegue(withIdentifier: "signUpToAnimationsSegue", sender: nil)
        print ("Succesfully created new user")
        
      } else {
        let alert = UIAlertController(title: "Sorry!", message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in})
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
  
}
