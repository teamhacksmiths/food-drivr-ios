//
//  DonationType.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/1/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class DonationType: Object, Mappable {
    dynamic var type_description: String?
    dynamic var quantity: Int = 0
    dynamic var unit: String?
    
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        type_description   <- map["description"]
        quantity           <- map["quantity"]
        unit               <- map["unit"]
    }
}