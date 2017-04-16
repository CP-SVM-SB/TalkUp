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

protocol GifsViewControllerDelegate {
    
    func reloadCollection()
    func selectCell(index: Int)
    func resetSelection()
    
}

import UIKit
import SwiftGifOrigin

class GifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, GifsViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let GiphyClient = Giphy()
    let refreshControl = UIRefreshControl()
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var delegate: ChatRoomViewController?
    var gifsArray = [String]()
    var gifsInCollectionSelected = [Bool](repeating: false, count:24)
    var dataArray = [Data]()
    var userSettings: UserSettings?
    var numCells = 24
    var url = String()
    var q = "reactions"
    var numCalls = 0
    var data = Data()
    var gifImage = UIImage()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        doneButton.setTitle("Done", for: .normal)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3.04, height: screenWidth/3.04)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView!.collectionViewLayout = layout
        
        self.getRandomGifs(query: q)
        
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var searchText = searchText
        
        if searchText.isEmpty {
            searchText = "reactions"
        } else {
            
            searchText = searchText.replacingOccurrences(of: " ", with: "+")
            
        }
        
        print(searchText)
        getRandomGifs(query: searchText)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.1) {
            self.setGifImages()
        }
        collectionView.reloadData()
        
    }



    func getRandomGifs(query: String) {
        self.gifsArray.removeAll()
        self.GiphyClient.makeSearchRequest(q: query, success: { (returnedArray: (NSArray)) in
            for i in 0...(returnedArray.count - 1) {
                
                    self.url = returnedArray.object(at: i) as! String
                    self.gifsArray.append(self.url)
            
            }
        }
            , failure: { (error: Error) in
            print (error.localizedDescription)
        })
        
        
    }
    

    func setGifImages(){
        
        dataArray.removeAll()
        var thisUrl = String()
        
        for i in 0...(gifsArray.count - 1) {
            
            DispatchQueue.global().async {
                do {
                    
                    thisUrl = self.gifsArray[i]
                    let imageUrl = URL(string: thisUrl)
                    self.data = try! Data(contentsOf: imageUrl!) // <--------- IS THE SLOW PART
                    self.dataArray.append(self.data)
                    //print(self.data)

                DispatchQueue.main.async(execute: {
                    
                        self.collectionView.reloadData()

                })
                }
            }
        }
        
        
    }
    
    
    func selectCell(index: Int){
        self.index = index
        gifsInCollectionSelected[index] = true
    }
    
    
    func resetSelection(){
        gifsInCollectionSelected = [Bool](repeating: false, count:24)
    }
    
    
    func reloadCollection(){
        collectionView.reloadData()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        
        dismiss(animated: true) {
            if self.index == nil {
                print(":)")
            }else{
                self.delegate?.sendValues(gifUrl: self.gifsArray[self.index], gifData: self.dataArray[self.index])
                
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataArray.count-1 >= self.numCells) ? self.numCells : self.dataArray.count-1        //alternative if statement syntax
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! GifsCollectionViewCell
        cell.gifImageView.image = UIImage.gif(data: dataArray[indexPath.row])
        cell.delegate = self
        cell.selectButton.tag = indexPath.row
        cell.selectButton.isSelected = gifsInCollectionSelected[cell.selectButton.tag]
        return cell
    }

}
