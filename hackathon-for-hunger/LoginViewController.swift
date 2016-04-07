//
//  LoginViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

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
        
        // https://github.com/teamhacksmiths/hackathon-for-hunger-ios/pull/6 
        // was not sure what to do with this, so commented it out and explained in the PR so I could merge
        //
        // This is from HEAD from feature_ba_
        // temporary hard login ( email driver@drivr.com )
        //let validLogin = "driver@drivr.com"
        //if emailInput.text ==  validLogin {
        //    self.performSegueWithIdentifier("DriverLoginSuccess", sender: self)
        //}
        
        //Suggestion for implementing the signIn
        //loginProvider = .Costum(emailInput.text!, passwordInput.text!)
        //loginProvider.login(self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("Main") as! DashboardViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("Left") as! MenuTableViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        self.presentViewController(slideMenuController, animated: false, completion: nil)
    }
    

    @IBAction func singUpUsingTwitter(sender: UIButton) {
        
        loginProvider = .Twitter
        loginProvider.login(self)
        
    }
    
    
    
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