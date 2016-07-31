//
//  UserUpdate.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 5/14/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//
//  based on RegistrationDTO.swift by Ian Gristock
//  hackathon-for-hunger


import Foundation
import JSONCodable

struct UserUpdate {
    
    
    var name: String?
    var phone: String?
    var email: String?
    var password: String?
    var password_confirmation: String?
    var avatar: String?
    var address: [Address] = []
    
}

extension UserUpdate: JSONEncodable {
    func toJSON() throws -> [String:AnyObject] {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(name, key: "name")
            try encoder.encode(phone, key: "phone")
            try encoder.encode(email, key: "email")
            try encoder.encode(password, key: "password")
            try encoder.encode(password_confirmation, key: "password_confirmation")
            try encoder.encode(avatar, key: "avatar")
            try encoder.encode(address, key: "addresses_attributes")
        })
    }
}
