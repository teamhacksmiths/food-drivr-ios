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


class VSUserInfoViewController: UIViewController {
    
    // Mark: Propety
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // Mark: Regular expression for email
    static private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    
    static private var user = UserRegistration()
    
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



extension VSUserInfoViewController {
    
    
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
//        DrivrAPI.sharedInstance.registerUser(VSUserInfoViewController.user, success: {
//                (JsonDict) in
//            print (JsonDict)
//            self.showAwaitingApprovalView()
//            }, failure: {
//                (error) in
//                self.showAlert(.Custom("Server", error!.description))
//        })
    }
    
    private func createUser() {
        VSUserInfoViewController.user.email = emailTextField.text
        VSUserInfoViewController.user.phone = phoneTextField.text
        VSUserInfoViewController.user.name = nameTextField.text
        VSUserInfoViewController.user.password = passwordTextField.text
        VSUserInfoViewController.user.role = .Donor
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
        let emailTest = NSPredicate(format:"SELF MATCHES %@", VSUserInfoViewController.emailRegEx)
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











