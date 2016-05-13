//
//  UserRouter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/2/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import Alamofire

enum UserEndpoint {
    case Login(credentials: UserLogin)
    case Register(userData: UserRegistration)
    case GetUser(token: Token)
    case Update(token: Token, userData: UserRegistration)
}

class UserRouter : BaseRouter {
    
    typealias JsonDict = [String: AnyObject]
    
    var endpoint: UserEndpoint
    init(endpoint: UserEndpoint) {
        self.endpoint = endpoint
    }
    
    override var method: Alamofire.Method {
        switch endpoint {
        case .Login: return .POST
        case .Register: return .POST
        case .GetUser: return .GET
        case .Update: return .PATCH
        }
    }
    
    override var path: String {
        switch endpoint {
        case .Login: return "sessions"
        case .Register: return "users"
        case .GetUser(let token): return "users/\(token.token)"
        case .Update(let token): return "users/\(token.token)"
        }
    }
    
    override var parameters: APIParams {
        switch endpoint {
        case .Login(let credentials):
            do {
                let credentials = try credentials.toJSON()
                return ["session": credentials]
            } catch {
                return [:]
            }

        case .Register(let userData):
            do {
                let user = try userData.toJSON()
                return ["user": user]
            } catch {
                return [:]
            }
        case .GetUser:
            return nil
            
        case .Update(_, let userData):
            do {
                let user = try userData.toJSON()
                return ["user": user]
            } catch {
                return [:]
            }
        }
//        case .Update(let userData):
//            do {
//                let user = try userData.userData.toJSON()
//                return ["user": user]
//            } catch {
//                return [:]
//            }
//        }
    }

    override var encoding: Alamofire.ParameterEncoding? {
        switch endpoint {
        case .Login: return .URL
        case .Register: return .URL
        case .GetUser: return .URL
        case .Update: return .URL
        }
    }
    
}