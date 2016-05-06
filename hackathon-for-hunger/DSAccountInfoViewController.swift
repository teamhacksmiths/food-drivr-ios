//
//  DSAccountInfoViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DSAccountInfoViewController: UIViewController {
    
    var donorSignupInfo: DonorSignupInfo!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTextFieldsPlaceHolder(UIColor.whiteColor())
    }
    
    // MARK: Action 
    
    
    @IBAction func signupWasPressed(sender: AnyObject) {
        if shouldSignup(){
            updateInfoStruct()
            signUpWith(donorSignupInfo)
        } else {
            updateTextFieldsPlaceHolder(UIColor.redColor())
            print("\nempty fields\n")
        }
    }
    
    // MARK: API
    
    func signUpWith(donor: DonorSignupInfo){
        var user = UserRegistration()
        user.name = donor.name!
        user.address = donor.adress!
        user.phone = donor.phone!
        user.email = donor.email!
        user.password = donor.password!
        user.password_confirmation = donor.password!
        user.role = .Donor
        
//        DrivrAPI.sharedInstance.registerUser(user, success: {
//            (JsonDict) in
//            print (JsonDict)
//            }, failure: {
//                (error) in
//                print(error)
//        })
    }
    
    // MARK: Helper
    
    func delegateRegistration() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func updateInfoStruct() {
        donorSignupInfo.email = emailTextField.text
        donorSignupInfo.password = passwordTextField.text
    }
    
    func shouldSignup() ->Bool {
        guard let email = emailTextField.text,
        password = passwordTextField.text
            else { return false }
        
        if email.isBlank { return false }
        if password.isBlank { return false }
        
        return true
    }
    
    // MARK: UI
    
    func updateTextFieldsPlaceHolder(color: UIColor){
        let textFields = [emailTextField, passwordTextField]
        for textField in textFields{
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: color])
        }
    }
    
}

extension DSAccountInfoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}