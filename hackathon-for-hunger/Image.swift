//
//  Image.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/3/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Image: Object, Mappable {
    
    dynamic var url: String? = nil
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        url <- map["url"]
    }
}