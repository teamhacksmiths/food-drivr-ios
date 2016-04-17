//
//  AuthProvider.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

class AuthProvider : NSObject {
    
    typealias JsonDict = [String: AnyObject]

    static let sharedInstance = AuthProvider()
    let realm = try! Realm()
    
    
    func getCurrentUser() -> User? {
        return realm.objects(User).first
    }
    
    func destroyUser() ->Void {
        let users = realm.objects(User)
        try! realm.write {
            realm.delete(users)
        }
    }
    
    func storeCurrentUser(user: JsonDict) -> User? {
        self.destroyUser()
        let user = User(dict: user)
            try! realm.write {
                realm.add(user)
            }
        return user
    }
    
    func setToken(token: String) -> Void {
        let tokenObj = Token()
        tokenObj.token = token
        try! realm.write {
            realm.delete(realm.objects(Token))
            realm.add(tokenObj)
        }
    }
    func getToken() -> Token? {
        return realm.objects(Token).first
    }
    
    func destroyToken() {
        try! realm.write {
        realm.delete(realm.objects(Token))
        }
    }
}