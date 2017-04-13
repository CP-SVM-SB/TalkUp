//
//  GifsViewController.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/9/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit

class GifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    let GiphyClient = Giphy()
    var gifsArray: [String] = []
    var userSettings: UserSettings?
    var numCells = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getRandomGifs()
        
        //print("VIEW DID LOAD", GiphyClient.makeRandomRequest())
        collectionView.delegate = self
        collectionView.dataSource = self
        doneButton.setTitle("Done", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = userSettings?.theme?.primaryColor
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomGifs(){
        for i in 1...numCells {
            var url = GiphyClient.makeRandomRequest()
            print(" HERE: ", GiphyClient.makeRandomRequest())
            gifsArray.append(url)
            
        }
        
        for j in 0...(numCells - 1) {
            print(gifsArray[j])
            
        }
    }
    
    
    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numCells
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! GifsCollectionViewCell
        //cell.layer.cornerRadius = cell.frame.size.width / 2;
        //print("IN CELL FOR ITEM AT: ", GiphyClient.makeRandomRequest())
        cell.urlLabel.text = GiphyClient.makeRandomRequest()
        cell.clipsToBounds = true
        //cell.urlLabel.text = gifsArray[indexPath.row]
        //print(GiphyClient.makeRandomRequest())
        //cell.delegate = self
        //cell.themeButton.tag = indexPath.row
        //cell.themeButton.isSelected = collectionCellSelected[cell.themeButton.tag]
        //cell.themeImageView.image = UIImage(named: themeImages[indexPath.row])
        
        return cell
    }

}
