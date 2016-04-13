//
//  DonationPin.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/3/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import MapKit

class DonationPin: NSObject, MKAnnotation {
    
    var donorInfo: DonorInfo? {
        didSet {
            lat = donorInfo?.lat
            lon = donorInfo?.lon
            title = donorInfo?.name
        }
    }
    var donation: Donation? {
        didSet {
            lat = donation?.pickup?.latitude.value
            lon = donation?.pickup?.longitude.value
            title = donation?.donor?.name
        }
    }
    var lat: Double?
    var lon: Double?
    var title: String?
    
    var coordinate: CLLocationCoordinate2D {
        set (newValue) {
            lat = newValue.latitude
            lon = newValue.longitude
        }
        get {
            if lat != nil && lon != nil {
                return CLLocationCoordinate2D(latitude: Double(lat!), longitude: Double(lon!))
            } else { // default values
                return CLLocationCoordinate2DMake(0.0, 0.0)
            }
        }
    }
}
