//
//  MetaData.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/1/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class MetaData: Object, Mappable {
    
    typealias JsonDict = [String: AnyObject]

    var images = List<Image>()
    var donationDescription: String? = nil
    
    convenience init(dict: JsonDict) {
        self.init()
        addImages(dict["images"] as? [JsonDict])
        if let description = dict["description"] as? String {
            donationDescription = description
        }
    }
    
    func addImages(images: [JsonDict]?) {
        if let newImages = images{
            for newImage in newImages {
                if let imageUrl = newImage["url"] {
                    self.images.append(Image(value: ["url": imageUrl]))
                }
            }
        }
    }
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        donationDescription <- map["description"]
        images              <- (map["images"], ListTransform<Image>())
    }
}