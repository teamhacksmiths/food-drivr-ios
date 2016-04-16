//
//  UserLogin.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/16/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

//
//  RegistrationDTO.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/15/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import JSONCodable


struct UserLogin {
    var email: String!
    var password: String!
}

extension UserLogin: JSONEncodable {
    func toJSON() throws -> [String:AnyObject] {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(email, key: "email")
            try encoder.encode(password, key: "password")
        })
    }
}
