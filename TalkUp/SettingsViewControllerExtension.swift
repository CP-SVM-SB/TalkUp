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
import Parse

extension SettingsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, SettingsTableViewControllerDelegate {
    

    
// ----------------------- ACTION FUNCTIONS --------------------------
    
    @IBAction func didTapLogOut(_ sender: UIButton) {
        print("loging out")
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        present(loginVC, animated: true, completion: nil)
        
    }

    @IBAction func notificationSwitchChanged(_ sender: Any) {
        print("switch changed")
    }
    
    func resetSelection(){
        collectionCellSelected = [false, false, false, false, false]
    }
    
    
    func selectCell(index: Int){
        collectionCellSelected[index] = true
    }
    
    
    func loadNewSelection(){
        collectionView.reloadData()
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
        cell.delegate = self
        cell.themeButton.tag = indexPath.row
        cell.themeButton.isSelected = collectionCellSelected[cell.themeButton.tag]
        cell.themeImageView.image = UIImage(named: themeImages[indexPath.row])
        
        return cell
    }
    
    
    
}
