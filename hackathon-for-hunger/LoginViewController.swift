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
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 25, 25), type: .BallRotateChase, color:  UIColor(red: 31/255, green: 198/255, blue: 227/255, alpha: 0.7), padding: 0)
    

    var loginProvider = LoginProvider.None
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        if let _ = AuthProvider.sharedInstance.getCurrentUser() {
            print("in here here")
            segueToMenuController()
        } else {
            AuthProvider.sharedInstance.destroyToken()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
    }
    
    func authReply(reply: String){
        /* alert code courtesy of iOS Creator (http://www.ioscreator.com/tutorials/display-an-alert-view-in-ios8-with-swift ) */
        let alertController = UIAlertController(title: "Food Drivr", message:
            "\(reply)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    
    }
    
    func checkAuth() -> Bool{
        if(emailInput.text!.isEmpty || passwordInput.text!.isEmpty){
            return false
        }
        return true
    }

    @IBAction func singInUsingFacebook(sender: UIButton) {
        loginProvider = .Facebook
        loginProvider.login(self)
    }

    @IBAction func signInButtonClicked(sender: AnyObject) {
        //Suggestion for implementing the signIn
        self.activityIndicator.startAnimation()
        if !checkAuth() {
            authReply("Please fill in both fields to proceed")
            self.activityIndicator.stopAnimation()
            return
        }
        loginProvider = .Custom(emailInput.text!, passwordInput.text!)
        loginProvider.login(self)
        
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
    
    func loginProvider(loginProvider: LoginProvider, didSucceed user: User?){
        self.segueToMenuController()
    }
    
    func loginProvider(loginProvider: LoginProvider, didFail error: NSError){
        self.activityIndicator.stopAnimation()
        authReply("Please supply valid credentials to proceed")
    }
    
}