//
//  DriverMapDetailPendingVC.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/9/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DriverMapDetailPendingVC: UIViewController, MKMapViewDelegate {
    
    var startingRegion = MapsDummyData.sharedInstance.startingRegion // used to retrieve precalculated starting region
    
    var annotationsHaveBeenShown: Bool = false //to allow auto zooming to pins, but just once
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    var donation: Donation?
    
    var pickupAnnotation: MKPointAnnotation?
    var dropoffAnnotation: MKPointAnnotation?
    //var pinAnnotationView: MKPinAnnotationView!
    
    
    //MARK:- Outlets & Actions
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var donorNameLabel: UILabel!
    
    @IBAction func acceptDonation(sender: AnyObject) {
        //findOnMap()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {

        mapView.delegate = self
        mapView.setRegion(startingRegion, animated: true)
        if donation != nil {
            donorNameLabel.text = donation?.donor?.name
            recipientNameLabel.text = donation?.recipient?.name
        }
        
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addPins()
        
        if donation != nil {
            donorNameLabel.text = donation?.donor?.name
        }
    }
    
    //MARK:- mapView
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print(annotationsHaveBeenShown)
        if annotationsHaveBeenShown != true {
            annotationsHaveBeenShown = true
            //mapView.showAnnotations([pickupAnnotation!, mapView.userLocation], animated: true)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
        
//        if let center = mapView.userLocation.location?.coordinate {
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
//            mapView.setRegion(region, animated: true)
//        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        if let annotation = pickupAnnotation {
//            mapView.deselectAnnotation(annotation, animated: true)
//            mapView.selectAnnotation(annotation, animated: true)
//        }
    }
    
    
    //MARK:- Annotations
    
    func addPins() { //TODO:- unwrap safely
        
        // In case there are any exisiting annotations, remove them
        if mapView.annotations.count != 0 {
//            annotation = self.mapView.annotations[0]
//            mapView.removeAnnotation(annotation)
            mapView.removeAnnotations(mapView.annotations)
        }
        
        // Set pin for pickup location
        pickupAnnotation = MKPointAnnotation()
        pickupAnnotation!.title = donation?.donor?.name
        
        pickupAnnotation!.coordinate = (donation?.pickup?.coordinates)!

        let pickupAnnotationView = MKPinAnnotationView(annotation: pickupAnnotation, reuseIdentifier: nil)
        pickupAnnotationView.pinTintColor = UIColor.greenColor()
        mapView.addAnnotation(pickupAnnotationView.annotation!)
        
        // Set pin for the optional dropoff location if it exists at this point
        if let dropoff = donation?.dropoff {
            dropoffAnnotation = MKPointAnnotation()
            dropoffAnnotation!.title = donation?.recipient?.name
            
            dropoffAnnotation!.coordinate = (dropoff.coordinates)!
            
            let dropoffAnnotationView = MKPinAnnotationView(annotation: dropoffAnnotation, reuseIdentifier: nil)
            pickupAnnotationView.pinTintColor = UIColor.brownColor()
            mapView.addAnnotation(dropoffAnnotationView.annotation!)
        } else {
            print("no dropoff location yet")
        }
    }
    
    
}
