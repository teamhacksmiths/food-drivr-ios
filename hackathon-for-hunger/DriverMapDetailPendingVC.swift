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
    
    //var annotationsHaveBeenShown: Bool = false //to allow auto zooming to pins, but just once
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    var donation: Donation?
    
    var pickupAnnotation: DonationPin?
    var dropoffAnnotation: DonationPin?

    
    
    //MARK:- Outlets & Actions
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientStreetLabel: UILabel!
    @IBOutlet weak var recipientCityLabel: UILabel!
    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var donorStreetLabel: UILabel!
    @IBOutlet weak var donorCityLabel: UILabel!
    
    @IBAction func acceptDonation(sender: AnyObject) {
        // segue to view controller with route
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {

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
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annotation in mapView.annotations {
            topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        
        // Add a little extra space on the sides
        region.span.latitudeDelta = abs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3
        region.span.longitudeDelta = abs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3
        
        region = mapView.regionThatFits(region)
        //mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(MKMapRectForCoordinateRegion(region), edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 0, right: 50), animated: true)
    }
    
    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
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
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView?.selected = true
            if annotation.isKindOfClass(DonationPin) == true {
                if let pickupDonationPin = annotation as? DonationPin {
                    
                    if pickupDonationPin.kind == .Pickup {
                        pinView!.leftCalloutAccessoryView = UIImageView(image:UIImage(named:"pickup"))
                        pinView?.pinTintColor = MapsDummyData.sharedInstance.pinColorPickup
                    } else if pickupDonationPin.kind == .Dropoff {
                        pinView!.leftCalloutAccessoryView = UIImageView(image:UIImage(named:"dropoff"))
                        pinView?.pinTintColor = MapsDummyData.sharedInstance.pinColorDropoff
                    }
                    let frame = CGRectMake(0.0, 0.0, 70.0, 50.0)
                    pinView!.leftCalloutAccessoryView?.frame = frame
                }
            }
            
        }
        else {
            pinView?.annotation = annotation
            pinView?.selected = true
        }
        
        return pinView

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
        mapView.selectAnnotation(pickupAnnotation!, animated: true)
        
        // Set pin for the optional dropoff location if it exists at this point
        if let dropoff = donation?.dropoff {
            
            dropoffAnnotation = DonationPin()
            dropoffAnnotation!.title = donation?.recipient?.name
            dropoffAnnotation!.coordinate = (dropoff.coordinates)!
            dropoffAnnotation!.kind = .Dropoff
            
            mapView.addAnnotation(dropoffAnnotation!)
            mapView.selectAnnotation(dropoffAnnotation!, animated: true)
            
            
        } else {
            recipientNameLabel.text = "no dropoff location yet"
            dropoffAnnotation?.title = "dropoff"
            
        }
        

        for annotation in mapView.annotations {
            mapView.selectAnnotation(annotation, animated: true)
        }
        
        zoomToFitMapAnnotations() // calling too early here - no user location yet?
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDriverPickupMap") {
            
            if let driverMapPickupVC = segue.destinationViewController as? DriverMapPickupVC {
                
                driverMapPickupVC.donation = donation
            }
        }
    }
    
    
}
