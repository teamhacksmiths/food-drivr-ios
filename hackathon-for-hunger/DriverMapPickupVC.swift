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
    
    enum PinType {
        case Dropoff
        case Pickup
    }
    
    var data = MapsDummyData.sharedInstance
    
    var startingRegion = MapsDummyData.sharedInstance.startingRegion // used to retrieve precalculated starting region
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    var donation: Donation?
    
    var pickupAnnotation: DonationPin?
    
    var kind: PinType = .Pickup
    
    var pickupRoute: MKPolylineRenderer?
    
    //MARK:- Outlets & Actions
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var donorStreetLabel: UILabel!
    @IBOutlet weak var donorCityLabel: UILabel!
    @IBOutlet weak var donorContactLabel: UILabel!
    @IBOutlet weak var donorPhoneLabel: UILabel!

    @IBOutlet weak var pickupDropoffButton: UIButton!
    @IBOutlet weak var cancelPickupButton: UIButton!
    @IBOutlet weak var buttonBackground: UIView!
    
    @IBAction func donationPickedUp(sender: AnyObject) {
        
        // Change button to Dropped Off and change the route from pickup to dropoff, but only if the route is currently set for pickup
        if kind == .Pickup {
            addDropoffPin()
            updateRoute()
        }
        
        kind = .Dropoff
        updateUI()
        
    }
    
    func donationDroppedOff() {
        print("Send message: dropoff complete")
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUI() {
        switch kind {
        case .Pickup:
            buttonBackground.backgroundColor = data.pinColorPickup
            pickupDropoffButton.setTitle("PICKED UP", forState: .Normal)
            cancelPickupButton.hidden = false
        case .Dropoff:
            buttonBackground.backgroundColor = data.pinColorDropoff
            pickupDropoffButton.setTitle("DROPPED OFF", forState: .Normal)
            cancelPickupButton.hidden = true
        }
    }
    
    //MARK:- get the route for the dropoff (//TODO:- refactor this func to use with either pickup or dropoff)
    func updateRoute() {
        if donation != nil {
            
            // remove the pickup route in prep to be replace with dropoff route
            //mapView.removeOverlays(mapView.overlays)
            
            // keep the pickup route on the map, but set the line thinner, and more transparent
            pickupRoute?.lineWidth = 3.5
            pickupRoute?.strokeColor = UIColor(red: 51/255, green: 195/255, blue: 0, alpha: 0.45)
            
            donorNameLabel.text = donation?.donor?.name
            
            // create Map Items
            let pickupPlacemark = MKPlacemark(coordinate: (donation!.pickup?.coordinates)!, addressDictionary: nil)
            let pickupMapItem = MKMapItem(placemark: pickupPlacemark)
            let dropoffPlacemark = MKPlacemark(coordinate: (donation!.dropoff?.coordinates)!, addressDictionary: nil)
            let dropoffMapItem = MKMapItem(placemark: dropoffPlacemark)
            
            // geet the route from pickup to dropoff
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
                    //self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
                if let first = self.mapView.overlays.first {
                    let rect = self.mapView.overlays.reduce(first.boundingMapRect, combine: {MKMapRectUnion($0, $1.boundingMapRect)})
                    self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), animated: true)
                }
            }
        }

    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {
        
        mapView.delegate = self
        mapView.setRegion(startingRegion, animated: true)
        
        updateUI()
        
        if donation != nil {
            donorNameLabel.text = donation?.donor?.name
            // TODO: need a street address for Donor Participant, to be passed to UI
            
            // create Map Items
            let userLocationMapItem = MKMapItem.mapItemForCurrentLocation()
            let pickupPlacemark = MKPlacemark(coordinate: (donation!.pickup?.coordinates)!, addressDictionary: nil)
            let pickupMapItem = MKMapItem(placemark: pickupPlacemark)
            
            // Create the route from user location to pickup
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
    
    
    //MARK:- MapView delegate methods
    
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
            pinView?.canShowCallout = true
            pinView?.selected = true
        }
        else {
            pinView?.annotation = annotation
            pinView?.selected = true
        }
        
        return pinView
    }
    
    // Set the appearance of the route polyline overlays
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        renderer.lineWidth = 4
        
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                
                // save a ref to pickup route renderer so that its alpha can be modified later,
                // when a 2nd overlay is added for the dropoff route
                pickupRoute = renderer
                
                switch kind {
                case .Pickup:
                    renderer.strokeColor = MapsDummyData.sharedInstance.routeColorPickup
                case .Dropoff:
                    renderer.strokeColor = MapsDummyData.sharedInstance.routeColorDropoff
                }
                
            } else if mapView.overlays.count > 1 {
                renderer.strokeColor = MapsDummyData.sharedInstance.routeColorDropoff                }
        }
        
        return renderer
    }

    
    
    //MARK:- Annotations
    
    func addPins() { //TODO:- unwrap safely
        
        // In case there are any exisiting annotations, remove them
        if mapView.annotations.count != 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        // Set pin for pickup location
        if donation != nil {
            
            pickupAnnotation = DonationPin()
            
            pickupAnnotation!.title = donation?.donor?.name
            pickupAnnotation!.coordinate = (donation?.pickup?.coordinates)!
            pickupAnnotation!.kind = .Pickup
            
            mapView.addAnnotation(pickupAnnotation!)
        }
    }
    
    //TODO: consolidate with addPin func
    func addDropoffPin() {
        if donation != nil {
            
            let dropoffAnnotation = DonationPin()
            
           
            dropoffAnnotation.title = donation?.recipient?.name
            dropoffAnnotation.coordinate = (donation?.dropoff?.coordinates)!
            dropoffAnnotation.kind = .Dropoff
            
            mapView.addAnnotation(dropoffAnnotation)
        }

    }
}


