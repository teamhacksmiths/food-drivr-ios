//
//  DictionaryStruct.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/15/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

protocol StructToDict {}

extension StructToDict {
    func toDict() -> [String:AnyObject] {
        var dict = [String:AnyObject]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                if let childValue = child.value as? AnyObject {
                    dict[key] = childValue
                }
            }
        }
        return dict
    }
}
