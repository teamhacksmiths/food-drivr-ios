//
//  Recipient.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/3/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Recipient: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var name: String?
    dynamic var street_address: String?
    dynamic var city: String?
    dynamic var zip_code: String?
    dynamic var state: String?
    dynamic var phone: String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        street_address  <- map["address"]
        city            <- map["city"]
        zip_code        <- map["zip_code"]
        phone           <- map["phone"]
        state           <- map["state"]
    }
}