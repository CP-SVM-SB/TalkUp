//
//  SettingsViewControllerExtension.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/1/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//


// MARK: THIS EXTENSION FILE IS FOR CELL CONTENT SETTINGS


import Foundation
import UIKit

extension SettingsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
// ----------------------- ACTION FUNCTIONS --------------------------
    
    
    
    @IBAction func didTapSave(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToMenu", sender: self)
        print("going back - Save")
        
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToMenu", sender: self)
        print("going back - Cancel")
        
    }

    @IBAction func notificationSwitchChanged(_ sender: Any) {
        
        print("switch changed")
        
//        if notificationSwitch.isOn == true {
//            notificationStateLabel.text = "ON"
//        }else{
//            notificationStateLabel.text = "OFF"
//        }

        
        
    }
    
// ------------------ COLLECTION VIEW DATASOURCE ----------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return themeImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "themeCell", for: indexPath) as! ThemeCollectionViewCell
        cell.backgroundColor = UIColor.gray
        cell.layer.cornerRadius = cell.frame.size.width / 2;
        cell.clipsToBounds = true
        //cell.layer.cornerRadius = 90
        cell.themeImageView.image = UIImage(named: themeImages[indexPath.row])
        
        return cell
    }
    
    
    
}
