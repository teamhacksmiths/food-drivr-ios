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
    
    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    var donorInfo: DonorInfo?
    var annotation: MKAnnotation!
    var pointAnnotation: MKPointAnnotation?
    var pinAnnotationView: MKPinAnnotationView!
    
    var keyboardHeight: CGFloat?
    
    //MARK:- Outlets & Actions
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var donorLabel: UILabel!

    
    @IBAction func acceptDonation(sender: AnyObject) {
        findOnMap()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {

        if donorInfo != nil {
            donorLabel.text = donorInfo!.name

        }
        
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //if locationTextField.text != nil {
            findOnMap()
        //}
    }
    
    //MARK:- mapView
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let center = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
            mapView.setRegion(region, animated: true)
        }
    }
    
    //MARK:- Geocoding
    
    func findOnMap() {
        
        
        // In case there are any exisiting annotations, remove them
        if mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            mapView.removeAnnotation(annotation)
        }
        
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(self.locationTextField.text!) { (placemarks, error) -> Void in
//            if (error != nil) {
//                self.configureUIForState(UIState.GeocodingError)
//                self.alert("Could not find that place")
//                return
//            }
//            if let placemark = placemarks?[0] {
//                let lat = placemark.location?.coordinate.latitude
//                let lon = placemark.location?.coordinate.longitude
//                let region = placemark.region as! CLCircularRegion
//                let mkregion = MKCoordinateRegionMakeWithDistance(
//                    region.center,
//                    region.radius,
//                    region.radius);
//                
//                self.pointAnnotation = MKPointAnnotation()
//                self.pointAnnotation!.title = self.locationTextField.text
//                self.pointAnnotation!.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
//                self.mapView.centerCoordinate = self.pointAnnotation!.coordinate
//                self.mapView.setRegion(mkregion, animated: true)
//                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
//                self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
//                self.mapView.selectAnnotation(self.pointAnnotation!, animated: true)
//                
//            }
//        }
    }
    
    
}
