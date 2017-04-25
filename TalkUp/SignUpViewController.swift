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
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var blurView: UIVisualEffectView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.passwordField.isSecureTextEntry = true
    bgImageView.image = UIImage(named: "signupBG")
    // placeholder text
    let placeholderColor = UIColor.lightGray
    //self.usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : placeholderColor] )
    self.emailField.font?.withSize(13)
    self.passwordField.attributedPlaceholder = NSAttributedString(string: "Repeat Password", attributes: [NSForegroundColorAttributeName : placeholderColor])
     self.emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : placeholderColor])
    
    self.registerButton.layer.borderColor = UIColor.white.cgColor
    self.registerButton.layer.borderWidth = 1
    self.registerButton.layer.cornerRadius = self.registerButton.frame.size.height / 2.0
    //self.blurView.layer.cornerRadius = 15
    self.registerButton.titleLabel?.textColor = .white
    
    
  }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    @IBAction func didTouchDismiss(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
    }
  
  @IBAction func onRegister(_ sender: UIButton) {
    let newUser = PFUser()
    newUser.username = emailField.text
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
