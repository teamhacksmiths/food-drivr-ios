//
//  Recipient.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/3/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

class Recipient: Object {
    dynamic var id: Int = 0
    dynamic var name: String?
    dynamic var street_address: String?
    dynamic var city: String?
    dynamic var zip_code: String?
    dynamic var state: String?
    dynamic var phone: String?
}