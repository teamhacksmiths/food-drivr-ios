//
//  RegistrationDTO.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/15/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
enum RegistrationRole: Int{
    case Donor = 0
    case Driver = 1
    case Other = 2
}
struct RegistrationDTO: StructToDict {
    

    
    var name: String?
    var address: String?
    var phone: String?
    var email: String?
    var password: String?
    var role: RegistrationRole = .Donor
    
}