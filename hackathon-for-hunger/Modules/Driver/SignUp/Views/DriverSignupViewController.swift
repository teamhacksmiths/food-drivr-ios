//
//  VSUserInfoViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

enum State {
    case IncompleteField
    case NotEmail
    case Custom(String, String)
    case None
}


class DriverSignupViewController: UIViewController {
    
    // Mark: Propety
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // Mark: Regular expression for email
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    
    private var user = UserRegistration()
    private let signupPresenter = DriverSignupPresenter(userService: UserService())
    
    var activityIndicator: ActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Registering")
        signupPresenter.attachView(self)
    }
    
    // MARK: Actions
    @IBAction func didPressSignUp(sender: AnyObject) {
        let donorIsApproved = false
        if donorIsApproved{
            
        } else {
            signUp()
        }
    }
    
    // MARK: Navigation
    
    func showAwaitingApprovalView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let awaitingApprovalViewController = storyboard.instantiateViewControllerWithIdentifier("AwaitingApprovalDriverView") as! AwaitingApprovalDriverViewController
        navigationController?.pushViewController(awaitingApprovalViewController, animated: true)
    }
    
}



extension DriverSignupViewController {
    
    
    func signUp() {
        
        let validationState = isValid()
        
        switch(validationState) {
            case .None:
                createUser()
                sendToServer()
            case .IncompleteField:
                showAlert(validationState)
            case .NotEmail:
                showAlert(validationState)
            default:
                return
        }
        
    }
    
    private func sendToServer() {
    self.startLoading()
    signupPresenter.register(self.user)
    }
    
    private func createUser() {
        self.user.email = emailTextField.text
        self.user.phone = phoneTextField.text
        self.user.name = nameTextField.text
        self.user.password = passwordTextField.text
        self.user.role = .Donor
    }
    
    private func isValid() -> State {
        
        if nameTextField.text == "" && phoneTextField.text == ""
            && emailTextField.text == "" && passwordTextField.text == "" {
            return .IncompleteField
        }else if !isValidEmail(emailTextField.text!) {
            return .NotEmail
        }
        return .None
        
    }
    
    // check if the email is valid
    private func isValidEmail(email: String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", self.emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
    
    private func showAlert(state: State) {
        
        var title = ""
        var message = ""
        let buttonTitle = "try"
        
        switch state {
        case .IncompleteField:
            title = "Incomplete Field"
            message = "Please ensure you complete all fields"
        case .NotEmail:
            title = "Incorrect email"
            message = "Please ensure you enter a valid email"
        case .Custom(let titleAlert, let messageAlert):
            title = titleAlert
            message = messageAlert
        case .None:
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default, handler: nil )
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
}

extension DriverSignupViewController: SignupView {
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        self.activityIndicator.stopAnimating()
    }
    
    func registration(sender: DriverSignupPresenter, didSucceed success: [String: AnyObject]) {
        self.activityIndicator.stopAnimating()
        self.showAwaitingApprovalView()
    }
    
    func registration(sender: DriverSignupPresenter, didFail error: NSError) {
        self.activityIndicator.stopAnimating()
        let alert = UIAlertController(title: "There was a problem", message: "Unable to register you at this time", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil )
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}