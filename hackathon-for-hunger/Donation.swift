//
//  Donation.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/30/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

enum DonationStatus: Int {
    case Pending
    case Active
    case Completed
}

class Donation: Object {
    dynamic var id: NSNumber!
    dynamic var donationDescription: String? = ""
    dynamic var donor: Participant?
    dynamic var driver: Participant?
    dynamic var recipient: Participant?
    dynamic var pickupCoordinates: Location?
    dynamic var dropoffCoordinates: Location?
    dynamic var initiated: NSDate = NSDate()
    dynamic var pickupTime: NSDate = NSDate()
    dynamic var dropoffTime: NSDate = NSDate()
    dynamic var expiryTime: NSDate = NSDate()
    let donationItems = List<DonationType>()
    private dynamic var rawStatus: Int = 0
    
    var status: DonationStatus {
        get{
            if let status = DonationStatus(rawValue: rawStatus) {
                return status
            }
            return .Pending
        }
        set{
            rawStatus = newValue.rawValue
        }
    }
}