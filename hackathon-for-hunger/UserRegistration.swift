//
//  RegistrationDTO.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/15/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import JSONCodable

enum RegistrationRole: Int{
    case Donor = 0
    case Driver = 1
    case Other = 2
}
struct UserRegistration {
    

    
    var name: String?
    var address: String?
    var phone: String?
    var email: String?
    var password: String?
    var password_confirmation: String?
    var role: RegistrationRole = .Donor
    
}

extension UserRegistration: JSONEncodable {
    func toJSON() throws -> [String:AnyObject] {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(name, key: "name")
            try encoder.encode(address, key: "address")
            try encoder.encode(phone, key: "phone")
            try encoder.encode(email, key: "email")
            try encoder.encode(password, key: "password")
            try encoder.encode(password_confirmation, key: "password_confirmation")
            try encoder.encode(role, key: "role")

        })
    }
}