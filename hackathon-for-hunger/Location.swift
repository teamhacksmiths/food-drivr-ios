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
import ObjectMapper

class Location: Object, Mappable {
    typealias JsonDict = [String: AnyObject]
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    dynamic var estimated: NSDate? = nil
    dynamic var actual: NSDate? = nil
    
    
    var coordinates: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        latitude        <- map["latitude"]
        longitude       <- map["longitude"]
        estimated       <- (map["estimated"], DateTransform())
        actual          <- (map["participants.driver"], DateTransform())
    }
}