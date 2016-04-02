//
//  Token.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

class Token {
    dynamic var token: String? = ""
    dynamic var refreshToken: String? = ""
    dynamic var expires_on: NSDate = NSDate()
}