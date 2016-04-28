//
//  StringExtensions.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/27/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

extension String{
    /// true if String is only white space
    var isBlank:Bool{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty
    }
}