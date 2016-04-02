//
//  Location.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/1/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Location: Object {
    
    let latitude: Double? = 0.0
    let longitude: Double? = 0.0
    
    var coordinates: CLLocationCoordinate2D? {
        if let latitude = latitude, longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}