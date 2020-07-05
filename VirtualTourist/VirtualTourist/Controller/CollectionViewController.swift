//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Rahaf Naif on 13/11/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit

class CollectionViewController : UICollectionViewController {
    
    var photosList = [photoInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        API.photoRequest(lat: PhotoAlbumViewController.coordinate.latitude, long: PhotoAlbumViewController.coordinate.longitude, completionHandler: {(photos,error) in
            self.photosList = (photos?.photos.photo)!
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = self.photosList[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.imageView.load(url: photo.imageUrl)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
    }
    
}
