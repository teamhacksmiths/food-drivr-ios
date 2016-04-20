//
//  LoginViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 15, 15), type: .BallScaleMultiple, color: UIColor.whiteColor(), padding: 0)
    

    var loginProvider = LoginProvider.None
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("here")
        if let _ = AuthProvider.sharedInstance.getCurrentUser() {
            print("in here here")
            segueToMenuController()
        } else {
            AuthProvider.sharedInstance.destroyToken()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func authReply(reply: String){
        /* alert code courtesy of iOS Creator (http://www.ioscreator.com/tutorials/display-an-alert-view-in-ios8-with-swift ) */
        let alertController = UIAlertController(title: "Food Drivr", message:
            "\(reply)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    
    }
    
    func checkAuth(){
        if(emailInput.text!.isEmpty || passwordInput.text!.isEmpty){
            authReply("Please fill in both fields to proceed")
        }
    }

    @IBAction func singInUsingFacebook(sender: UIButton) {
        loginProvider = .Facebook
        loginProvider.login(self)
    }

    @IBAction func signInButtonClicked(sender: AnyObject) {
        //Suggestion for implementing the signIn
        self.activityIndicator.startAnimation()
        loginProvider = .Custom(emailInput.text!, passwordInput.text!)
        loginProvider.login(self)
        checkAuth()
       // self.activityIndicator.stopAnimation()
        
    }
    

    @IBAction func singUpUsingTwitter(sender: UIButton) {
        
        loginProvider = .Twitter
        loginProvider.login(self)
        
    }
    
    private func segueToMenuController() {
        let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Main") as! DonationsOverviewViewController
        let leftViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Left") as! MenuTableViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        self.presentViewController(slideMenuController, animated: false, completion: nil)
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        print("calling segue")
    let authProvider = AuthProvider.sharedInstance
        authProvider.destroyUser()
        authProvider.destroyToken()
    }
}


extension LoginViewController: LoginProviderDelegate {
    
     // MARK: LoginProviderDelegate Method
    
    func loginProvider(loginProvider: LoginProvider, didSucceed user: [String: AnyObject]){
        self.segueToMenuController()
    }
    
    func loginProvider(loginProvider: LoginProvider, didFail error: NSError){
        print(error)
        authReply("Please supply valid credentials to proceed")
    }
    
}