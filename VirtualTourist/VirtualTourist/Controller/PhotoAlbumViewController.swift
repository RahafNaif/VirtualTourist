//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Rahaf Naif on 12/11/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController :UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKMapViewDelegate {
    
    static var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var text: UILabel!
    
    var photosList = [photoInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        var annotation = MKPointAnnotation()
        zoomingMap(PhotoAlbumViewController.coordinate, mapView: mapView)
        annotation.coordinate = PhotoAlbumViewController.coordinate
        self.mapView.addAnnotation(annotation)
        
        API.photoRequest(lat: PhotoAlbumViewController.coordinate.latitude, long: PhotoAlbumViewController.coordinate.longitude, completionHandler: {(photos,error) in
            self.photosList = (photos?.photos.photo)!
            if photos?.photos.total == "0"{
                DispatchQueue.main.async{
                    self.text.isHidden = false
                }
            }
            
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
            
        })
        
    }
    
    func zoomingMap(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = self.photosList[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.imageView.load(url: photo.imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfItemsPerRow:CGFloat = 3
//        let spacingBetweenCells:CGFloat = 2
//
//        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
//
//        if let collection = self.collectionView{
//            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//            return CGSize(width: width, height: width)
//        }else{
//            return CGSize(width: 0, height: 0)
//        }
//    }
    
}
