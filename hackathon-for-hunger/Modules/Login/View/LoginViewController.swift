//
//  LoginViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import CoreLocation

class LoginViewController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var activityIndicator : ActivityIndicatorView!
    private let loginPresenter = LoginPresenter(userService: UserService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter.attachView(self)
        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Please wait")
        //view.addSubview(self.activityIndicator)
        // Ask user for permission to use location services (should only ask the user the first time they use the app)
        let locationManager = LocationManager.sharedInstance.locationManager
        locationManager.delegate = LocationManager.sharedInstance
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func authReply(reply: String){
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

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        segueToMenuController()
    }
    
    private func segueToMenuController() {
        
        guard let user = AuthService.sharedInstance.getCurrentUser() else {
            authReply("Could not load user")
            return
        }
        
        switch user.userRole {
        case .Donor :
            self.performSegueWithIdentifier("loginAsDonor", sender: self)
            break
        case .Driver :
            self.performSegueWithIdentifier("loginAsDriver", sender: self)
            break
        }

    }
    
    @IBAction func signInButtonClicked(sender: AnyObject) {
        //Suggestion for implementing the signIn
        self.activityIndicator.startAnimating()
        if !checkAuth() {
            authReply("Please fill in both fields to proceed")
            self.activityIndicator.stopAnimating()
            return
        }
        loginPresenter.authenticate(UserLogin(email: emailInput.text!,password: passwordInput.text!))
    }
}


extension LoginViewController: LoginView {
    
     // MARK: LoginProviderDelegate Method
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        self.activityIndicator.stopAnimating()
    }
    
    func login(didSucceed user: User) {
        self.finishLoading()
        self.segueToMenuController()
    }
    
    func login(didFail error: NSError) {
        self.finishLoading()
        authReply("Please supply valid credentials to proceed")
    }
}