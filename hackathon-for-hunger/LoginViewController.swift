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
        //Suggestion for implementing the signIn
        loginProvider = .Custom(emailInput.text!, passwordInput.text!)
        loginProvider.login(self)
        
    }
    

    @IBAction func singUpUsingTwitter(sender: UIButton) {
        
        loginProvider = .Twitter
        loginProvider.login(self)
        
    }
    
    private func segueToMenuController() {
        let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Main") as! PendingDonationsDashboard
        let leftViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Left") as! MenuTableViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        self.presentViewController(slideMenuController, animated: false, completion: nil)
    }
    
    
}


extension LoginViewController: LoginProviderDelegate {
    
     // MARK: LoginProviderDelegate Method
    
    func loginProvider(loginProvider: LoginProvider, didSucceed user: [String: AnyObject]){
        self.segueToMenuController()
    }
    
    func loginProvider(loginProvider: LoginProvider, didFail error: NSError){
        print(error)
    }
    
}