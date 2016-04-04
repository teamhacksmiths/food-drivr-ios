//
//  DonorInfo.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 4/3/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

struct DonorInfo {
    var timestamp: NSDate?
    var name: String?
    var location: String?
    var lon: Double?
    var lat: Double?

    
    init() {
        // property values default to nil
    }
    
    init(data: NSDictionary) {
        /* Timestamp of donation, will be used later
        if let timestampString = data.valueForKey("updatedAt") as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let timestamp = dateFormatter.dateFromString(timestampString)
            self.timestamp = timestamp
        }
        */
        
        name = (data.valueForKey("name") as! String)
        
        if let mapString = data.valueForKey("mapString") as? String {
            location = mapString
        }
        if let lonString = (data.valueForKey("longitude") as? NSNumber) {
            lon = lonString.doubleValue
        }
        if let latString = (data.valueForKey("latitude") as? NSNumber) {
            lat = latString.doubleValue
        }

    }
}
