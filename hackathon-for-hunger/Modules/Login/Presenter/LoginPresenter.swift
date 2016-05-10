//
//  LoginProvider.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/6/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

protocol LoginView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func login(didSucceed user: User)
    func login(didFail error: NSError)
}

class LoginPresenter {
    private let userService:UserService
    private var loginView : LoginView?
    
    init(userService:UserService){
        self.userService = userService
    }
    
    func attachView(view:LoginView){
        loginView = view
    }
    
    func detachView() {
        loginView = nil
    }
    
    func authenticate(credentials: UserLogin){
        userService.authenticateUser(credentials).then() {
            user -> () in
            self.loginView?.login(didSucceed: user!)
            
            
            //temp check to get auth code so I can work with User Profile
            print(user)
            //////////////////
            
            
            }.error { error in 
            self.loginView?.login(didFail: error as NSError)
        }
    }
}