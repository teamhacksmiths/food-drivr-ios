//
//  AuthProvider.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation


class AuthProvider : NSObject {
    
    static let sharedInstance = AuthProvider()
    
    func getCredentials() -> Token? {
        return nil
    }
    
    func getCurrentUser() -> User? {
        return nil
    }
    
    func destroyUser() ->Void {
        
    }
    
    func storeCurrentUser() -> User? {
        return nil
    }
    
    func attemptLogin(username: String, password: String) throws -> User {
        throw HTTPStatusCode
    }
}