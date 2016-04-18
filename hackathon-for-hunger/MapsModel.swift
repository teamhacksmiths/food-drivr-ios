//
//  MapsModel.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/18/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift
import CoreLocation

class MapsModel {
    
    static let sharedInstance = MapsModel()

    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
    
    func getRegionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annotation in annotations {
            topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        
        // Add a little extra space on the sides
        region.span.latitudeDelta = abs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3
        region.span.longitudeDelta = abs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3
        
        return region
    }

}