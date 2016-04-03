//
//  LoginProvider.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 28/03/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation


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
                
                loginUsingFacebook(delegate)
            
            case .Twitter :
            
                loginUsingTwitter(delegate)
            
            case .Custom(let email, let password) :
                
                loginUsingCustom(delegate,email: email,password: password)
            
            case .None:
                //DO Nothing
                break
        }
        
        
    }
    
    
    private func loginUsingFacebook(delegate: LoginProviderDelegate) {
    
        //
        
    }
    
    
    private func loginUsingTwitter(delegate: LoginProviderDelegate) {
        
        
    }
    
    private func loginUsingCustom(delegate: LoginProviderDelegate,email: String,password: String) {

        DrivrAPI.sharedInstance.authenticate(email, password: password, completionHandler: {
            (response, error) in
            
            guard error == nil else {
                delegate.loginProvider(self, didFaild: error)
                return
            }
            delegate.loginProvider(self, didSucced: response)
        })
        
    }
    
    
    
}



