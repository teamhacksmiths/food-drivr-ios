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
    typealias JsonDict = [String: AnyObject]
    var latitude = RealmOptional<Double>()
    var longitude = RealmOptional<Double>()
    dynamic var estimated: NSDate? = nil
    dynamic var actual: NSDate? = nil
    
    
    var coordinates: CLLocationCoordinate2D? {
        if let latitude = latitude.value, longitude = longitude.value {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    convenience init(dict: JsonDict) {
        
        self.init()
        if let lat = dict["latitude"] as? String {
            self.latitude.value = Double(lat)
        }
        if let lon = dict["longitude"] as? String {
            self.longitude.value = Double(lon)
        }
        self.estimated = dict["estimated"] as? NSDate
        self.actual = dict["actual"] as? NSDate
    }
}