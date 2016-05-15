//
//  Participant.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/1/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftyJSON

class Participant: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var name: String? = ""
    dynamic var email: String? = ""
    dynamic var avatar: String? = ""
    dynamic var phone: String? = ""
    dynamic var role = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        email   <- map["email"]
        avatar  <- map["avatar"]
        phone   <- map["phone"]
        role    <- map["role"]
    }
}
