//
//  TopicsExtensionViewController2.swift
//  TalkUp
//
//  Created by Savannah McCoy on 4/15/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import Foundation
import UIKit


extension TopicsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout: UICollectionViewFlowLayout? = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)
        flowLayout?.minimumInteritemSpacing = 1.0
        flowLayout?.minimumLineSpacing = 1.0
        flowLayout?.sectionInset.left = 1.0
        flowLayout?.sectionInset.right = 1.0
        if indexPath.item % 3 == 0 {
            
            let cellWidth: CGFloat? = (collectionView.frame.width - ((flowLayout?.sectionInset.left)! + (flowLayout?.sectionInset.right)!))
            return CGSize(width: CGFloat(cellWidth!), height: 80)
        }
        else {
            //cellIndexArr.append(indexPath.item)
            let cellWidth: CGFloat? = (collectionView.frame.width - ((flowLayout?.sectionInset.left)! + (flowLayout?.sectionInset.right)!) - (flowLayout?.minimumInteritemSpacing)!) / 2
            return CGSize(width: CGFloat(cellWidth!), height: 80)
        }
        
        
    }
    


    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicCell", for: indexPath) as! TopicsCollectionViewCell
        cell.imageView.image = UIImage(data: imageDataArr[indexPath.row])
        cell.topicLabel.text = fakeTopicsArr[cellIndexArr[indexPath.row]]
        return cell
    }

    
    
}
