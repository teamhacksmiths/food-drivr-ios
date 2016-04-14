//
//  DriverMapPickupVC.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/13/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import MapKit

class DriverMapPickupVC: UIViewController, MKMapViewDelegate {
    
    var startingRegion = MapsDummyData.sharedInstance.startingRegion // used to retrieve precalculated starting region
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    var donation: Donation?
    
    var pickupAnnotation: MKPointAnnotation?
    
    
    
    //MARK:- Outlets & Actions
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var donorStreetLabel: UILabel!
    @IBOutlet weak var donorCityLabel: UILabel!
    @IBOutlet weak var donorContactLabel: UILabel!
    @IBOutlet weak var donorPhoneLabel: UILabel!
    
    @IBOutlet weak var pickupDropoffButton: UIBarButtonItem!

    @IBAction func donationPickedUp(sender: AnyObject) {

        pickupDropoffButton = UIBarButtonItem(title: "DROPPED OFF", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(donationDroppedOff))
        
        addDropoffPin()
        updateRoute()
        

    }
    
    func donationDroppedOff() {
        print("Send message: dropoff complete")
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- set the route (//TODO:- refactor this func to use with either pickup or dropoff)
    func updateRoute() {
        if donation != nil {
            
            // remove the pickup route in prep to be replace with dropoff route
            mapView.removeOverlays(mapView.overlays)
            
            donorNameLabel.text = donation?.donor?.name
            
            // create Map Items
            let pickupPlacemark = MKPlacemark(coordinate: (donation!.pickup?.coordinates)!, addressDictionary: nil)
            let pickupMapItem = MKMapItem(placemark: pickupPlacemark)
            let dropoffPlacemark = MKPlacemark(coordinate: (donation!.dropoff?.coordinates)!, addressDictionary: nil)
            let dropoffMapItem = MKMapItem(placemark: dropoffPlacemark)
            
            
            let request = MKDirectionsRequest()
            request.source = pickupMapItem
            request.destination = dropoffMapItem
            request.requestsAlternateRoutes = false
            request.transportType = .Automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }

    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {
        
        mapView.delegate = self
        mapView.setRegion(startingRegion, animated: true)
        
        if donation != nil {
            donorNameLabel.text = donation?.donor?.name
            // TODO: need a street address for Donor Participant, to be passed to UI
            
            // create Map Items
            let userLocationMapItem = MKMapItem.mapItemForCurrentLocation()
            let pickupPlacemark = MKPlacemark(coordinate: (donation!.pickup?.coordinates)!, addressDictionary: nil)
            let pickupMapItem = MKMapItem(placemark: pickupPlacemark)
            
            let request = MKDirectionsRequest()
            request.source = userLocationMapItem
            request.destination = pickupMapItem
            request.requestsAlternateRoutes = false
            request.transportType = .Automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
            
            addPins()
        }
        
    
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        

    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.75)
                renderer.lineWidth = 4
            } else {
                renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.4)
                renderer.lineWidth = 3
            }
        }
        return renderer
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    //MARK:- mapView
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView?.pinTintColor = MapsDummyData.sharedInstance.pinColor
        }
        else {
            pinView?.annotation = annotation
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
        if donation != nil {
            
            pickupAnnotation = MKPointAnnotation()
            
            pickupAnnotation!.title = donation?.donor?.name
            pickupAnnotation!.coordinate = (donation?.pickup?.coordinates)!
            
            
            let pickupAnnotationView = MKPinAnnotationView(annotation: pickupAnnotation, reuseIdentifier: nil)
            pickupAnnotationView.canShowCallout = true
            pickupAnnotationView.selected = true
            mapView.addAnnotation(pickupAnnotationView.annotation!)
        }
    }
    
    //TODO: consolidate with addPin func
    func addDropoffPin() {
        if donation != nil {
            
            let dropoffAnnotation = MKPointAnnotation()
            
           
            dropoffAnnotation.title = donation?.recipient?.name
            dropoffAnnotation.coordinate = (donation?.dropoff?.coordinates)!
            
            
            let dropoffAnnotationView = MKPinAnnotationView(annotation: dropoffAnnotation, reuseIdentifier: nil)
            dropoffAnnotationView.canShowCallout = true
            dropoffAnnotationView.selected = true
            mapView.addAnnotation(dropoffAnnotationView.annotation!)
        }

    }
}


