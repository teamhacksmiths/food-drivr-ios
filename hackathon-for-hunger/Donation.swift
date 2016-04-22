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
    case Any
}

class Donation: Object {
    
    typealias JsonDict = [String: AnyObject]
    
    dynamic var id: Int = 0
    dynamic var donor: Participant?
    dynamic var driver: Participant?
    dynamic var recipient: Recipient?
    dynamic var pickup: Location?
    dynamic var dropoff: Location?
    dynamic var meta: MetaData?
    dynamic var created_at: NSDate? = nil
    dynamic var updated_at: NSDate? = nil
    let donationItems = List<DonationType>()
    
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
    
    convenience init(dict: JsonDict) {
        
        self.init()
        self.id = dict["id"] as! Int
        self.rawStatus = dict["status_id"] as! Int
        self.created_at = formatStringToDate(dict["created_at"] as? String)
        self.updated_at = formatStringToDate(dict["updated_at"] as? String)
        
        if let newRecipient = dict["recipient"] as? JsonDict {
            self.recipient = Recipient(value: newRecipient)
        }
        if let meta = dict["meta"] as? JsonDict {
            self.meta = MetaData(dict: meta)
        }
        
        if var donationPickup = dict["pickup"] as? JsonDict {
            donationPickup["estimated"] = formatStringToDate(donationPickup["estimated"] as? String)
            donationPickup["actual"] = formatStringToDate(donationPickup["actual"] as? String)
            self.pickup = Location(dict: donationPickup)
        }
        
        if var donationDropoff = dict["dropoff"] as? JsonDict {
            donationDropoff["estimated"] = formatStringToDate(donationDropoff["estimated"] as? String)
            donationDropoff["actual"] = formatStringToDate(donationDropoff["actual"] as? String)
            self.dropoff = Location(dict: donationDropoff)
        }
        addDonations(dict["donation_types"] as? [String])
        addParticipants(dict["participants"] as? JsonDict)
    }
    
    func addDonations(donations: [String]?) {
        if let newDonationItems = donations{
            for donationItem in newDonationItems {
                print(donationItem)
                self.donationItems.append(DonationType(value: ["name": donationItem]))
            }
        }
    }
    
    func addParticipants(participants: JsonDict?) {
        if let participants = participants {
            if var driver = participants["driver"] as? JsonDict {
                driver["updated_at"] = formatStringToDate(driver["updated_at"] as? String)
                driver["created_at"] = formatStringToDate(driver["created_at"] as? String)
                self.driver = Participant(value: driver)
            }
            
            if var donor = participants["donor"] as? JsonDict {
                donor["updated_at"] = formatStringToDate(donor["updated_at"] as? String)
                donor["created_at"] = formatStringToDate(donor["created_at"] as? String)
                self.donor = Participant(value: donor)
            }
        }

    }
    
    private func formatStringToDate(dateString: String?, format: String = "yyyy-MM-dd'T'HH:mm:ss") -> NSDate? {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateString else {
            return nil
        }
        return dateFormatter.dateFromString(date)
    }
 }