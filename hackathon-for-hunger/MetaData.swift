//
//  MetaData.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/1/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

class MetaData: Object {
    
    typealias JsonDict = [String: AnyObject]

    let images = List<Image>()
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
}