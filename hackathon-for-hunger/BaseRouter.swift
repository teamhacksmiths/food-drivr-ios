//
//  BaseRouter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/30/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import Alamofire

public typealias JSONDictionary = [String: AnyObject]
typealias APIParams = [String : AnyObject]?

protocol APIConfiguration {
    var method: Alamofire.Method { get }
    var encoding: Alamofire.ParameterEncoding? { get }
    var path: String { get }
    var parameters: APIParams { get }
    var baseUrl: String { get }
}


class BaseRouter : URLRequestConvertible, APIConfiguration {

    init() {}
    
    var method: Alamofire.Method {
        fatalError("[BaseRouter - \(#function)] Must be overridden in subclass")
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        fatalError("[BaseRouter - \(#function))] Must be overridden in subclass")
    }
    
    var path: String {
        fatalError("[BaseRouter - \(#function))] Must be overridden in subclass")
    }
    
    var parameters: APIParams {
        fatalError("[BaseRouter - \(#function))] Must be overridden in subclass")
    }

    
    var baseUrl: String {
        var config: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("ApiKeys", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
        }
        var baseUrl = "";
        if let config = config {
            baseUrl = config["DRIVR_API_BASE_URL"] as! String
        }
        return baseUrl
    }
    
    var URLRequest: NSMutableURLRequest {
        let baseURL = NSURL(string: baseUrl);
        _ = NSURLRequest(URL: baseURL!.URLByAppendingPathComponent(path))
        let mutableURLRequest = NSMutableURLRequest(URL: baseURL!.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        if let encoding = encoding {
            return encoding.encode(mutableURLRequest, parameters: parameters).0
        }
        return mutableURLRequest
    }
}