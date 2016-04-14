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
    

    @IBAction func donationPickedUp(sender: AnyObject) {
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
        
        addPins()

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
    
    
}


    /*
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

