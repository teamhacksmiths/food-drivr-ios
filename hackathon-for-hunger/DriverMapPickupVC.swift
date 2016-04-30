//
//  DriverMapPickupVC.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/13/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//
//  Note: This View Controller is used for both the route to the pickup, and the route to the dropoff
//  since they are similar. Upon tapping Confirm Pickup, the UI is updated from pickup to dropoff route

import UIKit
import MapKit

class DriverMapPickupVC: UIViewController, MKMapViewDelegate {
    
    enum PinType {
        case Dropoff
        case Pickup
    }
    
    var mapsModel = MapsModel.sharedInstance
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
            pickupDropoffButton.setTitle("CONFIRM PICK UP", forState: .Normal)

        case .Dropoff:
            buttonBackground.backgroundColor = data.pinColorDropoff
            pickupDropoffButton.setTitle("CONFIRM DROP OFF", forState: .Normal)
            if donation != nil {
                if donation?.recipient != nil {
                    if donation?.recipient?.name != nil {
                        donorNameLabel.text = donation?.recipient?.name
                    }
                } else {
                    donorNameLabel.text = "No dropoff yet"
                }
            }
        }
    }
    
    //MARK:- get the route for the dropoff (//TODO:- refactor this func to use with either pickup or dropoff)
    func updateRoute() {
        if donation != nil {
            if donation?.recipient != nil {
                
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
                
                // get the route from pickup to dropoff
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
                        self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100.0, left: 100.0, bottom: 10.0, right: 100.0), animated: true)
                    }
                }
            }
        }
    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {
        
        mapView.delegate = self
        mapView.setRegion(startingRegion, animated: true) // set starting region to overview map's region?
        for annot in mapView.annotations {
            mapView.deselectAnnotation(annot, animated: true)
        }
        
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
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 100.0, left: 80.0, bottom: 10.0, right: 80.0), animated: true)

                }
                

            }
            
            addPins()
        }
        
    
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        zoomToFitMapAnnotations()
    }
    
    
    //MARK:- MapView delegate methods
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        //mapView.showAnnotations(mapView.annotations, animated: true)
        zoomToFitMapAnnotations()
        
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            if let annotation = annotationView.annotation as? DonationPin {
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                
                switch annotation.kind {
                    
                case .Pickup:
                    let placemark = MKPlacemark(coordinate: (annotationView.annotation?.coordinate)!, addressDictionary: nil)
                    let pickupMapItem = MKMapItem(placemark: placemark)
                    pickupMapItem.name = donation?.donor?.name
                    // with just 1 item, maps will give directions from user location to item
                    MKMapItem.openMapsWithItems([pickupMapItem], launchOptions: launchOptions)
                    
                case .Dropoff:
                    let pickupPlacemark = MKPlacemark(coordinate: (donation!.pickup?.coordinates)!, addressDictionary: nil)
                    let dropoffPlacemark = MKPlacemark(coordinate: (annotationView.annotation?.coordinate)!, addressDictionary: nil)
                    let pickupMapItem = MKMapItem(placemark: pickupPlacemark)
                    let dropoffMapItem = MKMapItem(placemark: dropoffPlacemark)
                    pickupMapItem.name = donation?.donor?.name
                    dropoffMapItem.name = donation?.recipient?.name
                    // with 2 items, directions will be from the 1st to the 2nd item
                    MKMapItem.openMapsWithItems([pickupMapItem, dropoffMapItem], launchOptions: launchOptions)
                }
            }
        }
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            if annotation.isKindOfClass(DonationPin) == true {
                if let pickupDonationPin = annotation as? DonationPin {
                    if pickupDonationPin.kind == .Pickup {
                        pinView!.leftCalloutAccessoryView = UIImageView(image:UIImage(named:"pickup"))
                        // uncomment the next line if using standard MKPinAnnotationView
                        //pinView?.pinTintColor = MapsDummyData.sharedInstance.pinColorPickup
                        pinView?.image = UIImage(named: "pin_green")
                    } else if pickupDonationPin.kind == .Dropoff {
                        pinView!.leftCalloutAccessoryView = UIImageView(image:UIImage(named:"dropoff"))
                        // uncomment the next line if using standard MKPinAnnotationView
                        //pinView?.pinTintColor = MapsDummyData.sharedInstance.pinColorDropoff
                        pinView?.image = UIImage(named: "pin_orange")
                    }
                    let leftFrame = CGRectMake(0.0, 0.0, 70.0, 50.0)
                    pinView!.leftCalloutAccessoryView?.frame = leftFrame
                    
                    let rightFrame = CGRectMake(0.0, 0.0, 58.0, 50.0)
                    let directionButton = UIButton(frame: rightFrame)
                    directionButton.setImage(UIImage(named: "directions_icon"), forState: UIControlState.Normal)
                    pinView!.rightCalloutAccessoryView?.frame = rightFrame
                    pinView!.rightCalloutAccessoryView = directionButton
                }
            }
            pinView?.canShowCallout = true
            //pinView?.selected = true
        }
        else {
            pinView?.annotation = annotation
            //pinView?.selected = true
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
            if donation?.recipient != nil {
                let dropoffAnnotation = DonationPin()
                
                
                dropoffAnnotation.title = donation?.recipient?.name
                dropoffAnnotation.coordinate = (donation?.dropoff?.coordinates)!
                dropoffAnnotation.kind = .Dropoff
                
                mapView.addAnnotation(dropoffAnnotation)
                //mapView.selectAnnotation(dropoffAnnotation, animated: true)
            }
        }

    }
    
    
    func zoomToFitMapAnnotations() {
        if mapView.annotations.count == 0 {
            mapView.setRegion(startingRegion, animated: true)
            return
        }
        
        let region = mapsModel.getRegionForAnnotations(mapView.annotations)
        
        mapView.setVisibleMapRect(mapsModel.MKMapRectForCoordinateRegion(mapView.regionThatFits(region)), edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 0, right: 50), animated: true)
    }
    
}


