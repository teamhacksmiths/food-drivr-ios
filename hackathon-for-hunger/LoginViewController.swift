//
//  LoginViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }


    @IBAction func logInUsingEmail(sender: UIButton) {
        
        LoginProvider.Custom(emailTextField.text!, passwordTextField.text!).login(self)
    }
    
    
    @IBAction func logInUsingFacebook(sender: UIButton) {
   
        LoginProvider.Facebook.login(self)
    }
    
    @IBAction func logInUsingTwitter(sender: UIButton) {
        
        LoginProvider.Twitter.login(self)
    }

}

extension LoginViewController: LoginProviderDelegate {
    
    
    func loginProvider(loginProvider: LoginProvider, didSucced user: [String: AnyObject]){
    
        //show the next screen 
    }
    
    func loginProvider(loginProvider: LoginProvider, didFaild error: NSError){
        
        //show alert
        
    }
    
    
}