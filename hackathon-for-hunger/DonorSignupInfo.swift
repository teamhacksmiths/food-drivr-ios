//
//  DonorSignupInfo.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/16/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

struct DonorSignupInfo{
    
    var name: String?
    var company: String?
    var adress: String?
    var phone: String?
    var email: String?
    var password: String? 
    
    init(){ }
    
    init(name: String, company: String, adress: String, phone: String, email: String, password: String){
        self.name = name
        self.company = company
        self.adress = adress
        self.phone = phone
        self.email = email
        self.password = password
    }
    
    init(name: String, company: String, adress: String, phone: String){
        self.name = name
        self.company = company
        self.adress = adress
        self.phone = phone
    }
    
}