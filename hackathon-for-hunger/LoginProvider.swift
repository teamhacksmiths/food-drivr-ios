//
//  LoginProvider.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 28/03/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit

protocol LoginProviderDelegate {
    
    func loginProvider(loginProvider: LoginProvider, didSucceed user: [String: AnyObject])
    func loginProvider(loginProvider: LoginProvider, didFail error: NSError)
    
}

//the purse is to not get conflic with the element of LoginProvider Twitter
typealias T = Twitter


enum LoginProvider {
    
    
    
    case Facebook
    
    case Twitter
    
    case Custom(String, String)
    
    case None
    
    
    func login(delegate: LoginProviderDelegate) {
        
        switch self {
            
            case .Facebook :
                
                loginUsingFacebook(delegate, viewController: delegate as! UIViewController)
            
            case .Twitter :
            
                loginUsingTwitter(delegate)
            
            case .Custom(let email, let password) :
                
                loginUsingCustom(delegate,email: email,password: password)
            
            case .None:
                //DO Nothing
                break
        }
        
        
    }
    
    static var facebookLoginManager = FBSDKLoginManager()
    static var permission  = ["public_profile","email"]
    
    struct FacebookKeys {
        static let email = "email"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let picture = "picture.type(large)"
        static let url = "url"
        static let data = "data"
        static let id = "id"
        static let pictureKey = "picture"
        
    }
    
    private func loginUsingFacebook(delegate: LoginProviderDelegate, viewController: UIViewController) {
    
        LoginProvider.facebookLoginManager.logInWithReadPermissions(LoginProvider.permission, fromViewController: viewController, handler: {
             (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            
            if error != nil {
                // if there's any error occur
                LoginProvider.facebookLoginManager.logOut()
                delegate.loginProvider(self, didFail: error)
                return
            } else if result.isCancelled {
                
                //when the user cancel
                LoginProvider.facebookLoginManager.logOut()
                let error = NSError(domain: "login is cancelled by the user", code: 0, userInfo: nil)
                delegate.loginProvider(self, didFail: error)
                return
            } else {
                
                //We create user from facebook
                if FBSDKAccessToken.currentAccessToken() != nil {
                    
                    let createFields = "\(FacebookKeys.firstName),\(FacebookKeys.lastName),\(FacebookKeys.email),\(FacebookKeys.picture)"
                    
                    let request = FBSDKGraphRequest(graphPath: "me",parameters: ["fields":"\(createFields)"])
                    
                    request.startWithCompletionHandler({(connection, result, error) -> Void in
                
                        if error != nil {
                            LoginProvider.facebookLoginManager.logOut()
                            delegate.loginProvider(self, didFail: error)
                            return
                        }
                        
                        guard let result = result as? NSDictionary else {
                            
                            let error = NSError(domain: "no information from facebook", code: 1, userInfo: nil)
                            delegate.loginProvider(self, didFail: error)
                            return
                        }
                        
                        //The information of user was picked correctly from facebook.
                        //We need create the a new dictionary , where to save information of the user.
                        //dictionary help us to pick the information easly
                        
                        let dictionary: [String: AnyObject] = [
                            FacebookKeys.email: result[FacebookKeys.email]!,
                            FacebookKeys.firstName: result[FacebookKeys.firstName]!,
                            FacebookKeys.lastName: result[FacebookKeys.lastName]!,
                            FacebookKeys.id: result[FacebookKeys.id]!,
                            //The path of picture picture/data/url
                            FacebookKeys.url: result[FacebookKeys.pictureKey]![FacebookKeys.data]!![FacebookKeys.url]!!
                        
                        ]
                        
                        delegate.loginProvider(self, didSucceed: dictionary)
                        
                    })
                }
            }
        })
    }
    
    static let  client = TWTRAPIClient()
    
    struct TwitterKeys {
        static let userID = "userID"
        static let name = "name"
        static let screenName = "screenName"
        static let isVerified = "isVerified"
        static let isProtected = "isProtected"
        static let profileImageURL = "profileImageURL"
        static let profileImageMiniURL = "profileImageMiniURL"
        static let profileImageLargeURL = "profileImageLargeURL"
        static let formattedScreenName = "formattedScreenName"

    }
    
    
    private func loginUsingTwitter(delegate: LoginProviderDelegate) {
        
        let method = TWTRLoginMethod.All
        
        T.sharedInstance().logInWithMethods(method, completion: {
            (session , error ) -> Void in
            
            
            guard error == nil else {
                delegate.loginProvider(self, didFail: error!)
                return
            }
            
            guard let session = session,
                let userID: String = session.userID  else {
                let error = NSError(domain: "error with the session", code: 3, userInfo: nil)
                delegate.loginProvider(self, didFail: error)
                return
            }
            
            
            //Create user from Twitter
//            LoginProvider.client.loadUserWithID(userID) { (user, error) -> Void in
//                
//                guard error == nil else{
//                    delegate.loginProvider(self, didFaild: error!)
//                    return
//                }
//                
//                guard let user = user else {
//                    let error = NSError(domain: "No data to display for the user", code: 4, userInfo: nil)
//                    delegate.loginProvider(self, didFaild: error)
//                    return
//                }
//                
//                
//                
//                //The information of user was picked correctly from twitter.
//                //We need create the a new dictionary , where to save information of the user.
//                //dictionary help us to pick the information easly
//                
//                
//                let dictionary: [String: AnyObject] = [
//                      TwitterKeys.userID: user.userID,
//                      TwitterKeys.name: user.name,
//                      TwitterKeys.screenName: user.screenName,
//                      TwitterKeys.isVerified: user.isVerified,
//                      TwitterKeys.isProtected: user.isProtected,
//                      TwitterKeys.profileImageURL: user.profileImageURL,
//                      TwitterKeys.profileImageMiniURL: user.profileImageMiniURL,
//                      TwitterKeys.profileImageLargeURL: user.profileImageLargeURL,
//                      TwitterKeys.formattedScreenName: user.formattedScreenName
//                ]
//                
//                delegate.loginProvider(self, didSucced: dictionary)
//                
//            }
            
            
        })
     
    
    }
    
    private func loginUsingCustom(delegate: LoginProviderDelegate,email: String,password: String) {
        
        DrivrAPI.sharedInstance.authenticate(email, password: password,
            success: {
                (JsonDict) in
            let user = AuthProvider.sharedInstance.storeCurrentUser(JsonDict)
                delegate.loginProvider(self, didSucceed: JsonDict)
            },
            failure: {
                error in
                delegate.loginProvider(self, didFail: : error)
            }
        
        )
    }
    
    
    
}





