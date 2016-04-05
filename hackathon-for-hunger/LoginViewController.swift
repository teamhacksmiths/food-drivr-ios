//
//  LoginViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    var loginProvider = LoginProvider.None
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func singInUsingFacebook(sender: UIButton) {
        loginProvider = .Facebook
        loginProvider.login(self)
    }

    @IBAction func signInButtonClicked(sender: AnyObject) {
        
        // temporary hard login ( email driver@drivr.com )
        let validLogin = "driver@drivr.com"
        if emailInput.text ==  validLogin {
            self.performSegueWithIdentifier("DriverLoginSuccess", sender: self)
        }

        //Suggestion for implementing the singIn
        //loginProvider = .Costum(emailInput.text!, passwordInput.text!)
        //loginProvider.login(self)
    }

//    @IBAction func singUpUsingTwitter(sender: UIButton) {
//        
//        loginProvider = .Twitter
//        loginProvider.login(self)
//        
//    }
//    
    
    
}


extension LoginViewController: LoginProviderDelegate {
    
     // MARK: LoginProviderDelegate Method
    
    func loginProvider(loginProvider: LoginProvider, didSucced user: [String: AnyObject]){
        
        print(user)
    }
    
    func loginProvider(loginProvider: LoginProvider, didFaild error: NSError){
        print(error)
    }
    
}