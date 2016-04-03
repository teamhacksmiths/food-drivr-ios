//
//  Participant.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/1/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

class Participant: Object {
    dynamic var id: Int = 0
    dynamic var updated_at: NSDate? = nil
    dynamic var created_at: NSDate? = nil
    dynamic var name: String? = ""
    dynamic var email: String? = ""
    dynamic var avatar: String? = ""
    dynamic var phone: String? = ""
    dynamic var role = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
