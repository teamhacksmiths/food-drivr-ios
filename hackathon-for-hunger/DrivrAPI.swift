//
//  DrivrAPI.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/31/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import Alamofire

class DrivrAPI {
    
    static let sharedInstance = DrivrAPI()
    let manager = Manager()
    
    init() {
    }
    
    func authenticate(username: String, password: String, completionHandler: ([String: AnyObject]?, NSError?)-> ()) {
        
        let router = UserRouter(endpoint: .Login(username: username, password: password) )

        manager.request(router)
            .validate()
            .responseJSON {
               response in
                switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    print(response)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
}