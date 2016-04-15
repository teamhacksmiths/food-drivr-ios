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
    
    func authenticate(username: String, password: String, success: (JsonDict)-> (), failure: (NSError?) ->()) {
        
        switch username {
            case "test@driver.com":
            let path = NSBundle.mainBundle().pathForResource("UserDriverMock", ofType: "json")
            let jsonData = NSData(contentsOfFile:path!)
            let json = JSON(data: jsonData!).dictionaryObject
            success(json!)
            break

        case "test@donor.com":
            let path = NSBundle.mainBundle().pathForResource("UserDonorMock", ofType: "json")
            let jsonData = NSData(contentsOfFile:path!)
            let json = JSON(data: jsonData!).dictionaryObject
            success(json!)
            break
        default:
            failure(NSError(domain: "error retrieving user", code:422, userInfo: nil))
            break
        }
                /*
        let router = UserRouter(endpoint: .Login(username: username, password: password) )

        manager.request(router)
            .validate()
            .responseJSON {
               response in
                switch response.result {
                case .Success(let JSON):                    
                    let response = JSON as! JsonDict
                    success(response)
                case .Failure(let error):
                    failure(error)
                }
        }*/
    }
    
    func registerUser(userData: RegistrationDTO, success: (JsonDict)-> (), failure: (NSError?) ->()) {
        let router = UserRouter(endpoint: .Register(userData: userData))
        
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