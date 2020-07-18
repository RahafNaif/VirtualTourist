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

class TravelLocationsViewController: UIViewController,MKMapViewDelegate,NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController : DataController!
    //var storedLocation: [Pin] = []
    var fetchedResultsController:NSFetchedResultsController<Pin>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
        addAnnotation()
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
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationOnMap
            annotation.title = "Info"
            self.mapView.addAnnotation(annotation)
            addPin(location: locationOnMap)
            
            
        }
    }

    func addPin(location: CLLocationCoordinate2D){

        let pin = Pin(context: dataController.viewContext)
        pin.latitude = location.latitude
        pin.longitude = location.longitude
        //let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        try? dataController.viewContext.save()

    }
    
    func addAnnotation(){
        var annotations = [MKPointAnnotation]()
        for pin in fetchedResultsController.fetchedObjects! {
            let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Info"
            annotations.append(annotation)
            
        }
        mapView.addAnnotations(annotations)
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let tapped = view.annotation?.title{
            PhotoAlbumViewController.coordinate = view.annotation!.coordinate
            for pin in fetchedResultsController.fetchedObjects! {
                if view.annotation?.coordinate.latitude == pin.latitude && view.annotation?.coordinate.longitude == pin.longitude {
                        performSegue(withIdentifier: "PhotoAlbum", sender: pin)
                }
            }
            
        }
    }
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            PhotoAlbumViewController.coordinate = view.annotation!.coordinate
//
////            let vc = PhotoAlbumViewController(nibName: nil, bundle: nil)
////            vc.dataController = dataController
////            navigationController?.pushViewController(vc, animated: true)
//
//            performSegue(withIdentifier: "PhotoAlbum", sender: self)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoAlbum"{
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! PhotoAlbumViewController
            vc.pin = sender as! Pin
            vc.dataController = dataController
        }
    }
    
}
