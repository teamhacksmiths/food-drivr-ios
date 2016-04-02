//
//  User.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    let id: Int! = nil
    dynamic var name: String? = ""
    dynamic var email: String? = ""
}