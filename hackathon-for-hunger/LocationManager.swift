//
//  LocationManager.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/8/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()

    var locationManager: CLLocationManager = CLLocationManager()
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("not loc auth yet?")
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            print("in LM del")
            // ...
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations.last
        //let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//      mapView.setRegion(region, animated: true)
        //locationManager.stopUpdatingLocation()
    }
    
}

