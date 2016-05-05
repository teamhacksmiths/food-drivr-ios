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
import PromiseKit

class DrivrAPI {
    
    static let sharedInstance = DrivrAPI()
    let manager = Manager()
    typealias JsonDict = [String: AnyObject]
    
    init() {
    }
    
    func authenticate(credentials: UserLogin) -> Promise<JsonDict> {
        let router = UserRouter(endpoint: .Login(credentials: credentials) )
       return Promise { fulfill, reject in
        manager.request(router)
            .validate()
            .responseJSON {
               response in
                switch response.result {
                case .Success(let JSON):                    
                    let response = JSON as! JsonDict
                    fulfill(response)
                case .Failure(let error):
                    print(error)
                    reject(NSError(domain: "error retrieving user", code:500, userInfo: nil))
                }
            }
        }
    }
    
    func authenticateUser(credentials: UserLogin) -> Promise<User?> {
        return Promise { fulfill, reject in
            self.authenticate(credentials).then() {
                token -> Void in
                AuthProvider.sharedInstance.setToken(token["authtoken"]!["auth_token"] as! String)
                self.getUser().then() {
                    userResponse -> Void in
                    if let newUser = userResponse["user"] as? [String: AnyObject] {
                        let user = AuthProvider.sharedInstance.storeCurrentUser(newUser)
                        fulfill(user)
                    } else {
                        reject(NSError(domain: "error retrieving user", code:422, userInfo: nil))
                    }
                }
                }.error { error in
                    reject(error as NSError)
            }
        }
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
    
    func getUser() -> Promise<JsonDict> {
        
        return Promise { fulfill, reject in
            
        guard let token = AuthProvider.sharedInstance.getToken() as Token? else {
            reject(NSError(domain: "no token found for user", code:422, userInfo: nil))
            return
        }
            
        let router = UserRouter(endpoint: .GetUser(token: token))
        
        manager.request(router)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .Success(let JSON):
                    let user = JSON as! JsonDict
                    fulfill(user)
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
        }
    
    
    func getDonations(completed: Bool = false, status: Int = 0) -> Promise<[JsonDict]> {
        return Promise { fulfill, reject in
            let router = DonationRouter(endpoint: .GetDonations(completed: completed, status: status) )
            
            manager.request(router)
                .validate()
                .responseJSON {
                    response in
                    switch response.result {
                    case .Success(let JSON):
                    
                        if let donations = JSON["donations"] as! [JsonDict]? {
                            fulfill(donations)
                        }
                        
                    case .Failure(let error):
                        print("REJECTING")
                        reject(error)
                    }
            }
        }
    }
    
    func updateRealmLayer(dict: [JsonDict]) -> Promise<Results<Donation>> {
        return Promise { fulfill, reject in
            let realm = try! Realm()
            try realm.write {
                realm.delete(realm.objects(Donation))
            }
            for donation: JsonDict in dict{
                do {
                    try realm.write {
                        realm.add(Donation(dict: donation), update: true)
                    }
                } catch let error as NSError{
                    reject(error)
                }
                
            }
            fulfill(realm.objects(Donation))
        }
    }
    
    func getDriverDonations() -> Promise<Results<Donation>> {
        return Promise { fulfill, reject in
            self.getDonations().then() {
                donationsJson in
                self.updateRealmLayer(donationsJson).then() {
                    realmObjects in
                    fulfill(realmObjects)
                }
                }.error {
                    error in
                    reject(error)
            }

        }
        
    }
    
    func updateDonationStatus(donation: Donation, status: DonationStatus) -> Promise<Void>{
        
        let accepted = ["status": [
            "donation_status": 1,
            "pickup_status": 1,
            "dropoff_status": 1
            ]
        ]
        
        let pickedUp = ["status": [
            "donation_status": 1,
            "pickup_status": 2,
            "dropoff_status": 1
            ]
        ]

        let droppedOff = ["status": [
            "donation_status": 2,
            "pickup_status": 2,
            "dropoff_status": 2
            ]
        ]
        var dict: JsonDict = [:]
        switch(status) {
        case .Active:
            dict = accepted
            break
        case .PickedUp:
            dict = pickedUp
            break
        case .Completed:
            dict = droppedOff
            break
        default: dict = accepted
        }
        return Promise { fulfill, reject in
            
            let router = DonationRouter(endpoint: .UpdateDonationStatus(donation: donation, status: dict))
            
            manager.request(router)
                .validate()
                .responseJSON {
                    response in
                    switch response.result {
                    case .Success(let JSON):
                        let user = JSON as! JsonDict
                        print(user)
                        fulfill()
                        
                    case .Failure(let error):
                        reject(error)
                    }
            }
        }
    }
}