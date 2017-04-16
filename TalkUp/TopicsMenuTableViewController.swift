//
//  TopicsMenuTableViewController.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/15/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import Parse

class TopicsMenuTableViewController: UITableViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var cell1Label: UILabel!
    @IBOutlet weak var cell2Label: UILabel!
    @IBOutlet weak var cell3Label: UILabel!
    @IBOutlet weak var cell4Label: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    var userSettings: UserSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.preservesSuperviewLayoutMargins = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
        
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.clipsToBounds = true
        
        cell1Label.text = "Online"
        cell2Label.text = "Settings"
        cell3Label.text = "Recent Topics"
        cell4Label.text = "Help"
        logOutButton.setTitle("Log Out", for: .normal)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        usernameLabel.text = userSettings?.username
        imageView.image = userSettings?.profileImage
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    @IBAction func didTapLogout(_ sender: UIButton) {
        
        print("loging out")
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        present(loginVC, animated: true, completion: nil)
    
    
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSettings"{
            let settingsVC = segue.destination as! SettingsTableViewController
            settingsVC.userSettings = self.userSettings
        }
        
        
    }
    

}
