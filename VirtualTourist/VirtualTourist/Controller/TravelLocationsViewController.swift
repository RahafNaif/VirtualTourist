//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Rahaf Naif on 11/11/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController : DataController!

    var storedLocations = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        try? dataController.viewContext.fetch(fetchRequest)
            
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
    
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
//            let pin =
//            NSEntityDescription.entity(forEntityName: "Pin", in:
//                dataController)
//            let newPin = NSManagedObject(entity: pin!, insertInto: dataController)
//                    newPin.setValue(locationOnMap.latitude , forKey:
//            "latitude")
//                    newPin.setValue(locationOnMap.longitude , forKey:
//            "longitude")
            let pin = Pin(context: dataController.viewContext)
            pin.latitude = locationOnMap.latitude
            pin.longitude = locationOnMap.longitude
            try? dataController.viewContext.save()
            
            addAnnotation(location: locationOnMap)
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D){
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Info"
        self.mapView.addAnnotation(annotation)
        
           
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            PhotoAlbumViewController.coordinate = view.annotation!.coordinate
            performSegue(withIdentifier: "PhotoAlbum", sender: self)
        }
    }
    
    
    
}
