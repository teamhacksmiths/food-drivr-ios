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
import RealmSwift

class DonationMapOverviewVC: UIViewController, MKMapViewDelegate {
    
    let dummyData = MapsDummyData.sharedInstance
    var donorInfoArray: [DonorInfo]?
    var donations: Results<Donation>?
    var realm = try! Realm()
    
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    @IBOutlet weak var mapView: MKMapView!
    
    // action for unwind segue
    @IBAction func unwindDetailToPendingMap(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    override func viewDidLoad() {

        mapView.showsUserLocation = true
        getDonations()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

//        if let center = mapView.userLocation.location?.coordinate {
//            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
//              mapView.setRegion(region, animated: true)
//        }
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

        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //TODO: might not need these checks here because all these pins are pickup pins
            if annotation.isKindOfClass(DonationPin) == true {
                if let pickupDonationPin = annotation as? DonationPin {
                    if pickupDonationPin.kind == .Pickup {
                        pinView!.pinTintColor = dummyData.pinColorPickup
                    }
                }
            }

            
        }
        else {
            pinView!.annotation = annotation
        }
        
        pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
//        let x = UIView(frame: CGRectMake(0, 0, 50, 80))
//        x.backgroundColor = UIColor.greenColor()
//        x.intrinsicContentSize()
//        pinView!.leftCalloutAccessoryView? = UIButton(type: .)
        pinView!.leftCalloutAccessoryView = UIImageView(image:UIImage(named:"pickup"))
        let frame = CGRectMake(0.0, 0.0, 70.0, 50.0)
        pinView!.leftCalloutAccessoryView?.frame = frame
        
//
//        let widthConstraint = NSLayoutConstraint(item: myView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
//        myView.addConstraint(widthConstraint)
//        
//        let heightConstraint = NSLayoutConstraint(item: myView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
//        myView.addConstraint(heightConstraint)
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            performSegueWithIdentifier("toDriverMapDetailPending", sender: annotationView.annotation)
            
        }
    }
    
    func getDonations() {
        let pendingDonations = realm.objects(Donation)
        guard pendingDonations.count > 0 else {
            self.fetchRemoteDonations()
            return
        }
        self.donations = pendingDonations
        readAndDisplayAnnotations()
    }
    
    private func fetchRemoteDonations() {
        DrivrAPI.sharedInstance.getDonations(success: {
            (results) in
            self.donations = results
            self.readAndDisplayAnnotations()
            }, failure: {
                (error) in
                print(error)
        })
    }
}

