//
//  SignupPresenter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/7/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

protocol SignupView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func registration(sender: DriverSignupPresenter, didSucceed success: [String: AnyObject])
    func registration(sender: DriverSignupPresenter, didFail error: NSError)
}

class DriverSignupPresenter {
    
    private let userService: UserService?
    private var signupView : SignupView?
    var realm = try! Realm()
    
    init(userService: UserService){
        self.userService = userService
    }
    
    func attachView(view: SignupView){
        signupView = view
    }
    
    func detachView() {
        signupView = nil
    }
    
    func register(userData: UserRegistration) {
        userService?.registerUser(userData).then() {
            user -> Void in
            self.signupView?.registration(self, didSucceed: user)
            }.error {
                error in
                self.signupView?.registration(self, didFail: error as NSError)
        }
    }
    
}