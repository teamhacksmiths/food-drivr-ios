//
//  UserService.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/6/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON
import PromiseKit

class UserService {
    
    let manager = Manager()
    typealias JsonDict = [String: AnyObject]

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
                    AuthService.sharedInstance.setToken(token["authtoken"]!["auth_token"] as! String)
                    self.getUser().then() {
                        userResponse -> Void in
                        if let newUser = userResponse["user"] as? [String: AnyObject] {
                            let user = AuthService.sharedInstance.storeCurrentUser(newUser)
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
    
    func registerUser(userData: UserRegistration) -> Promise<JsonDict> {
        return Promise { fulfill, reject in
            let router = UserRouter(endpoint: .Register(userData: userData))
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
    
    func getUser() -> Promise<JsonDict> {
        
        return Promise { fulfill, reject in
            
            guard let token = AuthService.sharedInstance.getToken() as Token? else {
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
    
    func updateUser(userData: UserUpdate) -> Promise<JsonDict> {
        return Promise { fulfill, reject in
            guard let token = AuthService.sharedInstance.getToken() as Token? else {
                reject(NSError(domain: "no token found for user", code:422, userInfo: nil))
                return
            }

            let router = UserRouter(endpoint: .Update(token: token, userData: userData))
            manager.request(router)
                .validate()
                .responseJSON {
                    response in

                    print(response.result.value)
                    switch response.result {
                        
                        
                    case .Success(_):
                        
                        print(response.result.value)

                        if let newUser = response.result.value!["user"] as? [String: AnyObject] {

                            _ = AuthService.sharedInstance.storeCurrentUser(newUser)
                            fulfill(newUser)
                        }
                        
                    case .Failure(let error):
                        reject(error)
                    }
            }
        }
    }
}