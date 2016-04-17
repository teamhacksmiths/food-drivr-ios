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
import SwiftyJSON

class DrivrAPI {
    
    static let sharedInstance = DrivrAPI()
    let manager = Manager()
    typealias JsonDict = [String: AnyObject]
    
    init() {
    }
    
    func authenticate(credentials: UserLogin, success: (JsonDict)-> (), failure: (NSError?) ->()) {
        let router = UserRouter(endpoint: .Login(credentials: credentials) )

        success(["authtoken": ["auth_token": "123129ashdhaskjdhkjasd"]])
        
//        manager.request(router)
//            .validate()
//            .responseJSON {
//               response in
//                switch response.result {
//                case .Success(let JSON):                    
//                    let response = JSON as! JsonDict
//                    success(response)
//                case .Failure(let error):
//                    failure(error)
//                }
//        }
    }
    
    func registerUser(userData: UserRegistration, success: (JsonDict)-> (), failure: (NSError?) ->()) {
        let router = UserRouter(endpoint: .Register(userData: userData))
        print("registering user")
        manager.request(router)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success(let JSON):
                    let user = JSON as! JsonDict
                    success(user)
                    
                case .Failure(let error):
                    failure(error)
                }
        }

    }
    
    func getUser(success: (JsonDict)-> (), failure: (NSError?) ->()) {
        print("getting user")
        let router = UserRouter(endpoint: .GetUser)
        
        manager.request(router)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success(let JSON):
                    let user = JSON as! JsonDict
                    success(user)
                    
                case .Failure(let error):
                    failure(error)
                }
        }
        
    }
    
    func getDonations(completed: Bool = false, status: Int = 0,  success: (Results<Donation>)-> (), failure: (NSError?) ->()) {
        print("getting donations")
        let router = DonationRouter(endpoint: .GetDonations(completed: completed, status: status) )
        
        manager.request(router)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success(let JSON):
                    
                    
                        let realm = try! Realm()
                        if let donations = JSON["donations"] as! [JsonDict]? {
                            for donation: JsonDict in donations{
                                try! realm.write {
                                    realm.add(Donation(dict: donation), update: true)
                                }
                            }

                        }
                        
                    success(realm.objects(Donation))
                    
                case .Failure(let error):
                    failure(error)
                }
        }
    }
}