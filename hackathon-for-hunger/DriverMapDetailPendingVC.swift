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
    var mapsModel = MapsModel.sharedInstance
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    var donation: Donation?
    
    var pickupAnnotation: DonationPin?
    var dropoffAnnotation: DonationPin?
    var activityIndicator: ActivityIndicatorView!
    
    
    //MARK:- Outlets & Actions
    
    // action for unwind segue
    @IBAction func unwindAcceptedToDetailPending(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientStreetLabel: UILabel!
    @IBOutlet weak var recipientCityLabel: UILabel!
    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var donorStreetLabel: UILabel!
    @IBOutlet weak var donorCityLabel: UILabel!
    
    @IBAction func acceptDonation(sender: AnyObject) {
       activityIndicator.startAnimating()
        DrivrAPI.sharedInstance.updateDonationStatus(donation!, status: .Active).then{
            donation in
            self.activityIndicator.stopAnimating()
        }
        
        // segue to view controller with route
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {
        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Accepting")
        self.view.addSubview(activityIndicator)
        mapView.delegate = self
        //mapView.setRegion(startingRegion, animated: true)
        if donation != nil {
            donorNameLabel.text = donation?.donor?.name
            // TODO: need a street address for Donor Participant, to be passed to UI
            if donation?.recipient != nil {
                recipientNameLabel.text = donation?.recipient?.name
                recipientStreetLabel.text = donation?.recipient?.street_address
                if let cityString = donation?.recipient?.city {
                    if let stateString = donation?.recipient?.state {
                        let cityStateString = cityString + ", " + stateString
                        if let zipString = donation?.recipient?.zip_code {
                            recipientCityLabel.text = cityStateString + " " + zipString
                        }
                    }
                }
            }
        }
        
        addPins()
        
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func zoomToFitMapAnnotations() {
        if mapView.annotations.count == 0 {
            mapView.setRegion(startingRegion, animated: true)
            return
        }
        
        let region = mapsModel.getRegionForAnnotations(mapView.annotations)
        
        mapView.setVisibleMapRect(mapsModel.MKMapRectForCoordinateRegion(mapView.regionThatFits(region)), edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 0, right: 50), animated: true)
    }
    
    
    
    //MARK:- mapView
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
//        if annotationsHaveBeenShown != true {
//            annotationsHaveBeenShown = true
        
        // mapView.showAnnotations(mapView.annotations, animated: true)
        zoomToFitMapAnnotations()
//            
//            mapView.setVisibleMapRect(mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), animated: true)
    //}
        //zoomToFitMapAnnotations()
        
    }
    

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var reuseId = "pin"
        if let pinAnnotation = annotation as? DonationPin {
            switch pinAnnotation.kind {
            case .Pickup:
                reuseId = "pickup"
            case .Dropoff:
                reuseId = "dropoff"
            }
            //}
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            
            if pinView == nil {
                //            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                //            pinView!.canShowCallout = true
                //            pinView?.selected = true
                //if annotation.isKindOfClass(DonationPin) == true {
                //                if let pickupDonationPin = annotation as? DonationPin {
                //                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                if pinAnnotation.kind == .Pickup {
                    pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pickup")
                    pinView?.leftCalloutAccessoryView = UIImageView(image:UIImage(named:"pickup"))
                    //pinView?.pinTintColor = MapsDummyData.sharedInstance.pinColorPickup
                    pinView?.image = UIImage(named: "pin_green")
                } else if pinAnnotation.kind == .Dropoff {
                    pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "dropoff")
                    pinView?.leftCalloutAccessoryView = UIImageView(image:UIImage(named:"dropoff"))
                    //pinView?.pinTintColor = MapsDummyData.sharedInstance.pinColorDropoff
                    pinView?.image = UIImage(named: "pin_orange")
                }
                let frame = CGRectMake(0.0, 0.0, 70.0, 50.0)
                pinView!.leftCalloutAccessoryView?.frame = frame
                pinView!.canShowCallout = true
                //pinView?.selected = true
            } else {
                // pinView already exists, and has been dequeued
                pinView?.annotation = annotation
                pinView!.canShowCallout = true
                //pinView?.selected = true
            }
            
            return pinView

            //}
        }
        
        // something went wrong with the pinView so:
        return nil

    }
    
    
    
    //MARK:- Annotations
    
    func addPins() { //TODO:- unwrap safely
        
        // In case there are any exisiting annotations, remove them
        if mapView.annotations.count != 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        // Set pin for pickup location
        pickupAnnotation = DonationPin()
        pickupAnnotation!.title = donation?.donor?.name
        pickupAnnotation!.coordinate = (donation?.pickup?.coordinates)!
        pickupAnnotation!.kind = .Pickup
        mapView.addAnnotation(pickupAnnotation!)
        //mapView.selectAnnotation(pickupAnnotation!, animated: true)
        
        // Set pin for the optional dropoff location if it exists at this point
        if let dropoff = donation?.dropoff {
            
            dropoffAnnotation = DonationPin()
            dropoffAnnotation!.title = donation?.recipient?.name
            dropoffAnnotation!.coordinate = (dropoff.coordinates)!
            dropoffAnnotation!.kind = .Dropoff
            
            mapView.addAnnotation(dropoffAnnotation!)
            //mapView.selectAnnotation(dropoffAnnotation!, animated: true)
            
            
        } else {
            recipientNameLabel.text = "no dropoff location yet"
            dropoffAnnotation?.title = "dropoff"
            
        }
        

//        for annotation in mapView.annotations {
//            mapView.selectAnnotation(annotation, animated: true)
//        }
        
        zoomToFitMapAnnotations() // calling too early here - no user location yet?
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "acceptedDonation") {
            
            if let driverMapPickupVC = segue.destinationViewController as? DriverMapPickupVC {
                
                driverMapPickupVC.donation = donation
            }
        }
    }
    
    
}
