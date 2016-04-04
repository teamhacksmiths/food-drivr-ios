//
//  MapsDummyData.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import MapKit

class MapsDummyData {
    static let sharedInstance = MapsDummyData()
    var donorInfoArray: [DonorInfo]?
    
    private init() {
        
        donorInfoArray = [DonorInfo]()
        
        let voodooDict: [String:AnyObject] = [
            "name": "Voodoo Doughnut",
            "mapString": "22 SW 3rd Ave. Portland, Oregon 97204",
            "latitude": 45.522711700000002,
            "longitude": -122.67307700000001
        ]
        let einsteinDict: [String:AnyObject] = [
            "name": "Einstein Bros Bagels",
            "mapString": "508 SW College St, Portland, OR 97201",
            "latitude": 45.5188767,
            "longitude": -122.6792907
        ]
        let starbucksDict: [String:AnyObject] = [
            "name": "Starbucks",
            "mapString": "720 SW Broadway, Portland, OR 97205",
            "latitude": 45.509282399999996,
            "longitude": -122.6832958
        ]
        
        let voodoo = DonorInfo(data: voodooDict)
        let einstein = DonorInfo(data: einsteinDict)
        let starbucks = DonorInfo(data: starbucksDict)
        
        self.donorInfoArray?.append(voodoo)
        self.donorInfoArray?.append(einstein)
        self.donorInfoArray?.append(starbucks)
        
//        geocodeAddress(voodoo) {success, coords in
//            if success {
//                voodoo.lat = Double(coords.latitude)
//                voodoo.lon = Double(coords.longitude)
//                self.donorInfoArray?.append(voodoo)
//            }
//        }
//        
//        geocodeAddress(einstein) {success, coords in
//            if success {
//                einstein.lat = Double(coords.latitude)
//                einstein.lon = Double(coords.longitude)
//                self.donorInfoArray?.append(einstein)
//            }
//        }
//        
//        geocodeAddress(starbucks) {success, coords in
//            if success {
//                starbucks.lat = Double(coords.latitude)
//                starbucks.lon = Double(coords.longitude)
//                self.donorInfoArray?.append(starbucks)
//            }
//        }
        
        
       
        
        
//        for info in donorInfoArray! {
////            let coordinates = geocodeAddress(info)
////            info.lat = coordinates.latitude
////            info.lon = coordinates.longitude
//            print("donor: \(info)")
//        }
        
    }
    
    func geocodeAddress(donorInfo: DonorInfo, completionHandler: (success: Bool, coords: CLLocationCoordinate2D) ->  Void) {
        let geocoder = CLGeocoder()
        var coord = CLLocationCoordinate2D()
        geocoder.geocodeAddressString(donorInfo.location!) { (placemarks, error) -> Void in
            
            if let placemark = placemarks?[0] {
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                let region = placemark.region as! CLCircularRegion
                let mkregion = MKCoordinateRegionMakeWithDistance(
                    region.center,
                    region.radius,
                    region.radius);
                coord.latitude = Double(lat!)
                coord.longitude = Double(lon!)
                
                print(coord)
                completionHandler(success: true, coords: coord)
            }
        }
        
        
    }

}
