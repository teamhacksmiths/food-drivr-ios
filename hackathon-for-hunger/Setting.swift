//
//  Setting.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 12/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Setting: Object, Mappable {
    dynamic var active = 0
    dynamic var notifications = 0
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        active             <- map["active"]
        notifications      <- map["notifications"]
    }
}