//
//  LoginProvider.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 28/03/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import FBSDKLoginKit


protocol LoginProviderDelegate {
    
    func loginProvider(loginProvider: LoginProvider, didSucced user: [String: AnyObject])
    func loginProvider(loginProvider: LoginProvider, didFaild error: NSError)
    
}





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
                delegate.loginProvider(self, didFaild: error)
                return
            } else if result.isCancelled {
                
                //when the user cancel
                LoginProvider.facebookLoginManager.logOut()
                let error = NSError(domain: "logIn is Cancelled by the user", code: 0, userInfo: nil)
                delegate.loginProvider(self, didFaild: error)
                return
            } else {
                
                //We create user from facebook
                if FBSDKAccessToken.currentAccessToken() != nil {
                    
                    let createFields = "\(FacebookKeys.firstName),\(FacebookKeys.lastName),\(FacebookKeys.email),\(FacebookKeys.picture)"
                    
                    let request = FBSDKGraphRequest(graphPath: "me",parameters: ["fields":"\(createFields)"])
                    
                    request.startWithCompletionHandler({(connection, result, error) -> Void in
                
                        if error != nil {
                            LoginProvider.facebookLoginManager.logOut()
                            delegate.loginProvider(self, didFaild: error)
                            return
                        }
                        
                        guard let result = result as? NSDictionary else {
                            
                            let error = NSError(domain: "no information from facebook", code: 1, userInfo: nil)
                            delegate.loginProvider(self, didFaild: error)
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
                        
                        delegate.loginProvider(self, didSucced: dictionary)
                        
                    })
                }
            }
        })
    }
    
    
    private func loginUsingTwitter(delegate: LoginProviderDelegate) {
        
        
    }
    
    private func loginUsingCustom(delegate: LoginProviderDelegate,email: String,password: String) {
        
        
    }
    
    
    
}





