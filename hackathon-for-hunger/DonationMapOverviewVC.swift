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

class DonationMapOverviewVC: UIViewController, MKMapViewDelegate {
    
    let dummyData = MapsDummyData.sharedInstance
    var donorInfoArray: [DonorInfo]?
    var donations: [Donation]?
    
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        donorInfoArray = dummyData.donorInfoArray
        donations = dummyData.donations
        mapView.showsUserLocation = true

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }

    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let center = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
              mapView.setRegion(region, animated: true)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        readAndDisplayAnnotations()
    }
    
    func readAndDisplayAnnotations() {
        
        var annotations = [DonationPin]()

        
        for donation in donations! { //TODO: - replace force unwrapping

            // create the annotation and set its properties
            let annotation = DonationPin()  // subclass of MKAnnotation()
            annotation.donation = donation
            annotation.kind = .Pickup

            // place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, add the annotations to the map.
        mapView.addAnnotations(annotations)
        //TODO:- fix the disconcerting animation that happens from the view after showAnnotations, changing to centering on user location
        mapView.showAnnotations(annotations, animated: true)
        
        // TODO: customize the callouts, and make sure they appear when pin is tapped
       
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDriverMapDetailPending") {
            
            if let pin = sender as? DonationPin {
                let donationVC = segue.destinationViewController as! DriverMapDetailPendingVC
                
                donationVC.donation = pin.donation
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // use the default animating blue dot if the view is the user location
        if annotation is MKUserLocation {
            return nil
        }
        
//        // This is false if it's the user location pin
//        
//        // TODO: refactor using MKUserLocation class
//        if annotation.isKindOfClass(DonationPin) == false {
//
//            let userPin = "userLocation"
//            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(userPin) {
//                return dequeuedView
//            } else {
//                _ = MKAnnotationView(annotation: annotation, reuseIdentifier: userPin)
//                
//                // returning nil allows the user location blue dot to be used
//                return nil
//            }
//            
//        }

        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //TODO: might not need these checks here because all these pins are pickup pins
            if annotation.isKindOfClass(DonationPin) == true {
                if let pickupDonationPin = annotation as? DonationPin {
                    if pickupDonationPin.kind == .Pickup {
                        pinView!.pinTintColor = dummyData.pinColor
                    }
                }
            }
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            performSegueWithIdentifier("toDriverMapDetailPending", sender: annotationView.annotation)
            
        }
    }
    
}

