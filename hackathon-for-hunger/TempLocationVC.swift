//
//  TempLocationVC.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/8/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import MapKit
import CoreLocation
import UIKit

// temporary view controller for placing the requests for user location authorization
// Put this code into the view controller that segues to the first map view that uses the user location
class TempLocationVC: UIViewController {

    
    var locationManager = LocationManager.sharedInstance.locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = LocationManager.sharedInstance
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
}
