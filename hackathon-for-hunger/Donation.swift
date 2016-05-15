//
//  Donation.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/30/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

enum DonationStatus: Int {
    case Pending = 0
    case Accepted
    case Suspended
    case Cancelled
    case PickedUp
    case DroppedOff
    case Any
}

class Donation: Object, Mappable {
    
    typealias JsonDict = [String: AnyObject]
    
    dynamic var id: Int = 0
    dynamic var donor: Participant?
    dynamic var driver: Participant?
    dynamic var recipient: Recipient?
    dynamic var pickup: Location?
    dynamic var dropoff: Location?
    dynamic var meta: MetaData?
    var donationItems = List<DonationType>()
    
    private dynamic var rawStatus = 0
    
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        rawStatus       <- map["status_id"]
        donor           <- map["participants.donor"]
        driver          <- map["participants.driver"]
        donationItems   <- (map["items"], ListTransform<DonationType>())
        pickup          <- map["pickup"]
        dropoff         <- map["dropoff"]
        recipient       <- map["recipient"]
        meta            <- map["meta"]
    }
 }