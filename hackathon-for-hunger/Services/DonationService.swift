//
//  DonationService.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/6/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON
import PromiseKit
import ObjectMapper

class DonationService {
    
    let manager = Manager()
    let realm = try! Realm()
    
    typealias JsonDict = [String: AnyObject]
    
    func getDonations(completed: Bool = false, status: Int = 0) -> Promise<[Donation]?> {
        return Promise { fulfill, reject in
            let router = DonationRouter(endpoint: .GetDonations(completed: completed, status: status) )
            
            manager.request(router)
                .validate()
                .responseJSON {
                    response in
                    switch response.result {
                    case .Success(let JSON):
                        print(JSON["donations"] as! [JsonDict]?)
                        let donations = Mapper<Donation>().mapArray(JSON["donations"] as! [JsonDict]?)
                        fulfill(donations)
                    case .Failure(let error):
                    if let data = response.data {
                        let responseJSON = JSON(data: data)
                        print("HERE")
                        print(responseJSON)
                        if let message: String = responseJSON["message"].stringValue {
                            if !message.isEmpty {
                                print(responseJSON)
                            }
                        }
                    }
                        print("REJECTING")
                        reject(error)
                    }
            }
        }
    }
    
    func updateRealmLayer(donations: [Donation]?) -> Promise<Results<Donation>> {
        return Promise { fulfill, reject in
            
            try realm.write {
                realm.delete(realm.objects(Donation))
            }
            if !donations!.isEmpty {
                do {
                    try realm.write {
                        realm.add(donations!, update: true)
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
                    realmObjects -> Void in
                    print(realmObjects)
                    fulfill(realmObjects)
                }
                }.error {
                    error in
                    reject(error)
            }
            
        }
        
    }
    
    func updateDonationStatus(donation: Donation, status: DonationStatus) -> Promise<Donation>{
        
        return Promise { fulfill, reject in
            
            let router = DonationRouter(endpoint: .UpdateDonationStatus(donation: donation, status: ["donation_status": status.rawValue]))
            manager.request(router)
                .validate()
                .responseJSON {
                    response in
                    switch response.result {
                    case .Success(_):
                        do {
                            try self.realm.write {
                                donation.status = status
                            }
                            
                        } catch let error as NSError{
                            reject(error)
                        }
                        fulfill(donation)
                    case .Failure(let error):
                        reject(error)
                    }
            }
        }
    }
}