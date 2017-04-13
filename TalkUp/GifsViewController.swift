//
//  GifsViewController.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/9/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//
/*
FOR  LATER REFERENCE: 
 
let url = URL(string: url)
let data = try? Data(contentsOf: url!)
let gifImage = UIImage.gif(data: data!)
imageView.image = gifImage
 
 */

import UIKit

class GifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    let GiphyClient = Giphy()
    let myDispatchGroup = DispatchGroup()

    var gifsArray = [String]()
    var userSettings: UserSettings?
    var numCells = 25
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myDispatchGroup.enter()
        myDispatchGroup.leave()
        
        myDispatchGroup.notify(queue: .main) {
            print("HERE")
            self.getRandomGifs()
        }
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
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

        self.GiphyClient.makeRandomSearchRequest(success: { (returnedArray: (NSArray)) in
            
            
            for i in 0...(returnedArray.count - 1){
                let object = returnedArray.object(at: i) as! [String:Any]
                
                self.url = object["url"] as! String
                
                self.gifsArray.append(self.url)
                
                print("URL: ", self.url)
                
            }

            
            //self.url = gifurl
            
            self.collectionView.reloadData()
            
        }, failure: { (error: Error) in
            print (error.localizedDescription)
        })
        
//        for j in 0...(numCells - 1) {
//            print(gifsArray[j])
//            
//        }
        
        print(gifsArray.count)
        
    }
    
    
    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.gifsArray.count > self.numCells) ? self.numCells : self.gifsArray.count        //alternative if statement syntax
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! GifsCollectionViewCell
        //cell.layer.cornerRadius = cell.frame.size.width / 2;
        //print("IN CELL FOR ITEM AT: ", GiphyClient.makeRandomRequest())
        //let url = self.GiphyClient.makeRandomRequest()
        //cell.urlLabel.text = url
        
        cell.clipsToBounds = true
        cell.urlLabel.text = gifsArray[indexPath.row]
        
        //print(GiphyClient.makeRandomRequest())
        //cell.delegate = self
        //cell.themeButton.tag = indexPath.row
        //cell.themeButton.isSelected = collectionCellSelected[cell.themeButton.tag]
        //cell.themeImageView.image = UIImage(named: themeImages[indexPath.row])
        
        return cell
    }

}
