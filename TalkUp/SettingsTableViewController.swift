//
//  SettingsTableViewController.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
// ----------------------- VARIABLES --------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var notificationStateLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!

    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var fontSizeLabel1: UIButton!
    @IBOutlet weak var fontSizeLabel2: UIButton!
    @IBOutlet weak var fontSizeLabel3: UIButton!
    
    var testInfo = ["Email","Phone", "Notifications"]
    var testHeaders = ["Account", "Appearance", " "]
    var themeImages = ["Theme1.png","Theme2.png", "Theme3.png", "Theme4.png", "Theme5.png"]

   
// ----------------------- LOAD METHODS --------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        self.tableView.separatorInset.bottom = 0.0
//        self.tableView.layoutMargins.bottom = 0.0
//        self.tableView.preservesSuperviewLayoutMargins = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.title = "Settings"
        
        
        if notificationSwitch.isOn == true {
            notificationStateLabel.text = "ON"
        }else{
            notificationStateLabel.text = "OFF"
        }
        
        fontSizeLabel1.layer.borderWidth = 1
        fontSizeLabel1.layer.cornerRadius = 6
        fontSizeLabel1.layer.borderColor = UIColor.purple.cgColor
        
        fontSizeLabel2.layer.borderWidth = 1
        fontSizeLabel2.layer.cornerRadius = 6
        fontSizeLabel2.layer.borderColor = UIColor.purple.cgColor
        
        fontSizeLabel3.layer.borderWidth = 1
        fontSizeLabel3.layer.cornerRadius = 6
        fontSizeLabel3.layer.borderColor = UIColor.purple.cgColor
        
        logOutButton.layer.cornerRadius = 27
        
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// --------------------- TABLE VIEW DATA SOURCE -----------------------


    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = testHeaders[section]
        return title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        }else {
            return 1
        }
    
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) //as! AccountTableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
