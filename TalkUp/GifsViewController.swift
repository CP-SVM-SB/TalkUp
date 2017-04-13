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
import SwiftGifOrigin

class GifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
   
    
    let GiphyClient = Giphy()
    let myDispatchGroup = DispatchGroup()
    var gifsArray = [String]()
    var dataArray = [Data]()
    var userSettings: UserSettings?
    var numCells = 25
    var url = String()
    var numCalls = 0
    var data = Data()
    var gifImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.getRandomGifs()
    
        doneButton.setTitle("Done", for: .normal)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = userSettings?.theme?.primaryColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.setGifImages()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapReload(_ sender: UIButton) {
        print("clicked")
        collectionView.reloadData()
    }
    
    //  THIS FUNCTION IS LIGHTNING FAST
    func getRandomGifs() {
        
        self.GiphyClient.makeRandomSearchRequest(success: { (returnedArray: (NSArray)) in
            
            for i in 0...(returnedArray.count - 1) {
                    
                    self.url = returnedArray.object(at: i) as! String
                    self.gifsArray.append(self.url)
            
            }
        }
            , failure: { (error: Error) in
            print (error.localizedDescription)
        })
        
        
    }
    
    //  THIS FUNCTION IS TURTLE SLOW
    func setGifImages(){
        
        var thisUrl = String()
        
        thisUrl = gifsArray[numCalls]
        
        let imageUrl = URL(string: thisUrl)
        
        self.data = try! Data(contentsOf: imageUrl!) // <--------- IS THE SLOW PART
        
        self.dataArray.append(self.data)
        
        print(self.data)
        
        self.collectionView.reloadData() // <--This does not happen until this function is done :/
                                         //     HOW DO I FIX THIS?
        
        numCalls = numCalls + 1
        
        if (numCalls < 24){
            
            setGifImages()
            
        }
        
    }
    
    
    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("here")
        return (self.dataArray.count >= self.numCells) ? self.numCells : self.dataArray.count        //alternative if statement syntax
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! GifsCollectionViewCell
        
        cell.gifImageView.image = UIImage.gif(data: dataArray[indexPath.row])
        cell.clipsToBounds = true
        cell.urlLabel.text = gifsArray[indexPath.row]
        
        
        return cell
    }

}
