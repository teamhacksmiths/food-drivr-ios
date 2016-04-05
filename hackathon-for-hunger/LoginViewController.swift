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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func signInButtonClicked(sender: AnyObject) {
        
        // temporary hard login ( email driver@drivr.com )
        let validLogin = "driver@drivr.com"
        if emailInput.text ==  validLogin {
            self.performSegueWithIdentifier("DriverLoginSuccess", sender: self)
        }
    }

}

