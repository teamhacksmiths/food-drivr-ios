//
//  DonationMapOverviewVC.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/3/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DonationMapOverviewVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let dummyData = MapsDummyData.sharedInstance
    var donorInfoArray: [DonorInfo]?
    
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    @IBOutlet weak var mapView: MKMapView!
    
//    func locationManager(manager: CLLocationManager,
//                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        print("not loc auth yet?")
//        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
//            print("in LM del")
//            // ...
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Error: \(error.localizedDescription)")
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//        mapView.setRegion(region, animated: true)
//        locationManager.stopUpdatingLocation()
//    }
    
    override func viewDidLoad() {
        donorInfoArray = dummyData.donorInfoArray
        mapView.showsUserLocation = true
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DonationMapOverviewVC.readAndDisplayAnnotations), name: refreshNotificationKey, object: nil)
//        navigationController?.title = "Pending Donations"
//        donorInfoArray = [DonorInfo]()
//        let dictionary: [String:AnyObject] = [
//            "name": "Einstein's Bagels",
//            "mapString": "101 Cooper St. Santa Cruz, CA",
//            "longitude": -122.0,
//            "latitude": 36.5
//        ]
//        let sampleDonor = DonorInfo(data: dictionary)
//        donorInfoArray?.append(sampleDonor)
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = LocationManager.sharedInstance
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
//        if CLLocationManager.authorizationStatus() == .NotDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        
        mapView.showsUserLocation = true

    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        readAndDisplayAnnotations()
    }
    
    func readAndDisplayAnnotations() {
//        if let _studentInfoArray = OnTheMapData.sharedInstance.studentInfoArray {
        
            // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [DonationPin]()
//        guard let donorInfoArray = donorInfoArray else {
//            print("donorInfo nil?")
//            return
//        }

        for donorInfo in donorInfoArray! {
            //TODO: - replace force unwrapping
            
            // create the annotation and set its properties
            let annotation = DonationPin()  // subclass of MKAnnotation()
            annotation.donorInfo = donorInfo

            // place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, add the annotations to the map.
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
        mapView.showsUserLocation = true
        print("User is at: \(mapView.userLocation.coordinate)")
        print(mapView.userLocationVisible)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DonationDetail") {
            
            if let pin = sender as? DonationPin {
                let donationVC = segue.destinationViewController as! DonationMapViewController
                
                donationVC.donorInfo = pin.donorInfo
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print(annotation)
        // This is false if its a user pin
        if annotation.isKindOfClass(DonationPin) == false {

            let userPin = "userLocation"
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(userPin) {
                return dequeuedView
            } else {
                let mkAnnotationView:MKAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userPin)
                // To customize the image
                //mkAnnotationView.image = UIImage(named: C_GPS.ROUTE_WALK_ICON_NAME)
                //let offset:CGPoint = CGPoint(x: 0, y: -mkAnnotationView.image!.size.height / 2)
                //mkAnnotationView.centerOffset = offset
                
                return nil//mkAnnotationView
            }
            
        }

        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            performSegueWithIdentifier("DonationDetail", sender: annotationView.annotation)
            
        }
    }
    
    //    // Use this "select" function to tap the pin (currently we are tapping the annotation view instead)
    //    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    //        // Unless the annotation is deselected, it is not selectable when returning from the collection view
    //        mapView.deselectAnnotation(view.annotation, animated: false)
    //
    //        self.performSegueWithIdentifier("DonationDetail", sender: view.annotation)
    //    }
}

