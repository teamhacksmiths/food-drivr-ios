//
//  ProfilePresenter.swift
//  hackathon-for-hunger
//
//  Created by David Fierstein on 5/14/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

protocol ProfileView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func update(didSucceed user: [String: AnyObject])
    func update(didFail error: NSError)
    func getUser(didSucceed user: [String: AnyObject])
    func getUser(didFail error: NSError)
}

class ProfilePresenter {
    private let userService: UserService
    private let authService: AuthService
    private var profileView: ProfileView?
    
    init(userService: UserService, authService: AuthService){
        self.userService = userService
        self.authService = authService
    }
    
    func attachView(view: ProfileView){
        profileView = view
    }
    
    func detachView() {
        profileView = nil
    }
    
    func getUser() -> User? {
        return authService.getCurrentUser()
//        userService.getUser().then() {
//            user -> () in
//            self.profileView?.getUser(didSucceed: user)
//        }
    }
    
    func updateUser(userData: UserUpdate) {
        
        userService.updateUser(userData).then() {
            updatedUser -> () in
            
            self.profileView?.update(didSucceed: updatedUser)
            
            }.error { error in
                
            self.profileView?.update(didFail: error as NSError)
        }
    }
    
}