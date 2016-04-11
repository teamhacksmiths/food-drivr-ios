//
//  AuthProvider.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

class AuthProvider : NSObject {
    
    typealias JsonDict = [String: AnyObject]

    static let sharedInstance = AuthProvider()
    let realm = try! Realm()
    
    func getCredentials() -> User? {
        realm.objects(User).first
    }
    
    func getCurrentUser() -> User? {
        return nil
    }
    
    func destroyUser() ->Void {
        var users = realm.objects(User)
        try! realm.write {
            realm.delete(users)
        }
    }
    
    func storeCurrentUser(user: JsonNDict) -> User? {
        self.destroyUser()
        var user = User(dict: user)
            try! realm.write {
                realm.add(user)
            }
        return user
    }
}