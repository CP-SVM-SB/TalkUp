//
//  SecondarySettingsViewController.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/7/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class SecondarySettingsViewController: UIViewController {

    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var enableVMView: UIView!
    @IBOutlet weak var fontSizeView: UIView!
    @IBOutlet weak var encryptMessagesView: UIView!
    
    var whichView = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if whichView == "password" {
            passwordView.isHidden = false
        }else if whichView == "enableVM" {
            enableVMView.isHidden = false
        }else if whichView == "font" {
            fontSizeView.isHidden = false
        }else if whichView == "encrypt" {
            encryptMessagesView.isHidden = false
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
