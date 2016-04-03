//
//  DrivrAPI.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/31/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class DrivrAPI {
    
    static let sharedInstance = DrivrAPI()
    let manager = Manager()
    typealias JsonDict = [String: AnyObject]
    
    init() {
    }
    
    func authenticate(username: String, password: String, completionHandler: (JsonDict?, NSError?)-> ()) {
        
        let router = UserRouter(endpoint: .Login(username: username, password: password) )

        manager.request(router)
            .validate()
            .responseJSON {
               response in
                switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! JsonDict
                    print(response)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func getDonations(completed: Bool? = false, dateRange: String?, completionHandler: (Results<Donation>?, NSError?)-> ()) {
        
        let router = DonationRouter(endpoint: .GetDonations(completed: completed!, dateRange: dateRange) )
        
        manager.request(router)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success(let JSON):
                    
                    let donations = JSON as! [JsonDict]
                    let realm = try! Realm()
                    for donation:JsonDict in donations {
                        try! realm.write {
                            realm.add(Donation(dict: donation), update: true)
                        }
                    }
                    completionHandler(realm.objects(Donation), nil)
                    
                case .Failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
}