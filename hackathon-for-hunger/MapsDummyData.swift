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
import CoreLocation

class MapsDummyData {
    static let sharedInstance = MapsDummyData()
    var donorInfoArray: [DonorInfo]? // temp. container to pass info
    var donations: [Donation]?
    var startingRegion = MKCoordinateRegion()
    
    let pinColor: UIColor
    
    private init() {
        donations = [Donation]()
        donorInfoArray = [DonorInfo]()
        
        pinColor = UIColor(red: 16/255, green: 176/255, blue: 198/255, alpha: 1)
        
        geocodeInitialRegion("Portland, OR")
        
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
        
        for info: DonorInfo in donorInfoArray! {
            
            let donor = Participant()
            donor.name = info.name
            let pickup = Location()//(dict: ["latitude": 45.509282399999996, "longitude": -122.6832958])
            
            // where will id come from?
            
            let donation = Donation()//    dict: ["id": 1, "status": 1, "donor": donor, "pickup": pickup])
            donation.donor = donor
            pickup.latitude = RealmOptional(info.lat)
            pickup.longitude = RealmOptional(info.lon)
            donation.pickup = pickup
            
            donations?.append(donation)
        }
        
        

        
        let donation01 = Donation()
        
        let location01 = Location()
        location01.latitude = RealmOptional(voodoo.lat)
        location01.longitude = RealmOptional(voodoo.lon)
        
        let participant01 = Participant()
        participant01.name = voodoo.name
        
        let recipient01 = Recipient()
        recipient01.name = "Oregon Food Bank"
        recipient01.street_address = "7900 NE 33rd Dr"//, Portland, OR 97211"
        recipient01.city = "Portland"
        recipient01.state = "OR"
        recipient01.zip_code = "97211"
        if let street_address = recipient01.street_address, city = recipient01.city, state = recipient01.state, zip_code = recipient01.zip_code {

            let place = street_address + " " + city + " " + state + " " + zip_code

            geocodeLocation(place) { success, coords in
                if success {

                    donation01.recipient = recipient01
                    self.donations![0].recipient = recipient01
                    let dropoff = Location()
                    dropoff.latitude = RealmOptional(coords.latitude)
                    dropoff.longitude = RealmOptional(coords.longitude)
                    
                    donation01.dropoff = dropoff
                    self.donations![0].dropoff = dropoff
                    self.donations![1].dropoff = dropoff
                    

                } else {
                    print("Geocode not successful")
                }
            }
        } else {
            print("Couldn't get recipient address")
        }
        

        donation01.pickup = location01
        donation01.donor = participant01


        
        //TODO: Needed data: need mapString or equivalent for geocoding for Participant or Location, contactInfo (distinct from name) for donor (what is avatar?)
        
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
    
    func geocodeInitialRegion(place: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(place) { (placemarks, error) -> Void in

            if let placemark = placemarks?[0] {
                let region = placemark.region as! CLCircularRegion
                let mkregion = MKCoordinateRegionMakeWithDistance(
                    region.center,
                    region.radius,
                    region.radius);
                self.startingRegion = mkregion

            }
        }
    }
}
