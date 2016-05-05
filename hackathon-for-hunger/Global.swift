//
//  Global.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/27/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

struct RegularExpressions{
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}