//
//  SettingsTableViewController.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit


protocol SettingsTableViewControllerDelegate {
    func loadNewSelection()
    func selectCell(index: Int)
    func resetSelection()
    func reloadView()
}

class SettingsTableViewController: UITableViewController {

    
// ----------------------- VARIABLES --------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    //cells
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    @IBOutlet weak var cell5: UITableViewCell!
    @IBOutlet weak var cell6: UITableViewCell!
    @IBOutlet weak var cell7: UITableViewCell!
    @IBOutlet weak var cell8: UITableViewCell!
    @IBOutlet weak var cell9: UITableViewCell!
    @IBOutlet weak var cell10: UITableViewCell!
    
    
    
    var theme: Theme?
    var collectionCellSelected = [Bool]()
    var testHeaders = ["Legal", "Account", "Appearance", " "]
    var themeImages = ["Theme1.png","Theme2.png", "Theme3.png", "Theme4.png", "Theme5.png"]

   
// ----------------------- LOAD METHODS --------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self

        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.title = "Settings"

        logOutButton.layer.cornerRadius = 24
        logOutButton.layer.borderColor = UIColor.lightGray.cgColor
        
        collectionCellSelected = [false, false, false, false, false]
        print("CCS Count: ", collectionCellSelected.count)
    
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
            return 4
        } else if section == 1 {
            return 3
        }else if section == 2{
            return 2
        }else{
            return 1
        }
    
    }

   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let secondarySettingsVC = segue.destination as! SecondarySettingsViewController
        
        if segue.identifier == "fromPassword" {
            secondarySettingsVC.whichView = "password"
        } else if segue.identifier == "fromVM"{
            secondarySettingsVC.whichView = "enableVM"
        } else if segue.identifier == "fromFont" {
            secondarySettingsVC.whichView = "font"
        } else if segue.identifier == "fromEM" {
            secondarySettingsVC.whichView = "encrypt"
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


}
