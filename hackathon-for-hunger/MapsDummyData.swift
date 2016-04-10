//
//  MapsDummyData.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class MapsDummyData {
    static let sharedInstance = MapsDummyData()
    var donorInfoArray: [DonorInfo]? // temp. container to pass info
    var donations: [Donation]?

    
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
        
        // temp., to be replaced by Realm objects
        donorInfoArray?.append(voodoo)
        donorInfoArray?.append(einstein)
        donorInfoArray?.append(starbucks)
        
        //MARK:- Realm objects
        
        let location01 = Location()
        location01.latitude = RealmOptional(voodoo.lat)
        location01.longitude = RealmOptional(voodoo.lon)
        
        let participant01 = Participant()
        participant01.name = voodoo.name
        
        let recipient01 = Participant()
        recipient01.name = "Oregon Food Bank"
        let ofb_address = "7900 NE 33rd Dr, Portland, OR 97211"
        geocodeLocation(ofb_address) { success, coords in
            if success {
                print("Coords: \(coords)")
            }
        }
        
        let donation01 = Donation()
        donation01.pickup = location01
        donation01.donor = participant01
        
        donations?.append(donation01)
        
        //TODO: Needed data: need mapString or equivalent for location, contactInfo (distinct from name) for donor, address for geocoding (in Location?)

        
    }
    
    func geocodeLocation(location: String, completionHandler: (success: Bool, coords: CLLocationCoordinate2D) ->  Void) {
        let geocoder = CLGeocoder()
        var coord = CLLocationCoordinate2D()
        geocoder.geocodeAddressString(location) { (placemarks, error) -> Void in
            
            if let placemark = placemarks?[0] {
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                let region = placemark.region as! CLCircularRegion
                _ = MKCoordinateRegionMakeWithDistance(
                    region.center,
                    region.radius,
                    region.radius);
                coord.latitude = Double(lat!)
                coord.longitude = Double(lon!)
                
                completionHandler(success: true, coords: coord)
            }
        }
        
        
    }

    
    func geocodeAddress(donorInfo: DonorInfo, completionHandler: (success: Bool, coords: CLLocationCoordinate2D) ->  Void) {
        let geocoder = CLGeocoder()
        var coord = CLLocationCoordinate2D()
        geocoder.geocodeAddressString(donorInfo.location!) { (placemarks, error) -> Void in
            
            if let placemark = placemarks?[0] {
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                let region = placemark.region as! CLCircularRegion
                _ = MKCoordinateRegionMakeWithDistance(
                    region.center,
                    region.radius,
                    region.radius);
                coord.latitude = Double(lat!)
                coord.longitude = Double(lon!)
                
                completionHandler(success: true, coords: coord)
            }
        }
        
        
    }

}
