//
//  DSUserInfoViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DSUserInfoViewController: UIViewController {
    
    var donorSignupInfo: DonorSignupInfo!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        donorSignupInfo = DonorSignupInfo()
        delegateRegistration()
        updateTextFieldsPlaceHolder(UIColor.whiteColor())
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    // MARK: Actions
    
    @IBAction func didPressNext(sender: UIButton) {
        if shouldTransition(){
            updateInfoStruct()
            performSegueWithIdentifier("DonorAccountInfo", sender: nil)
        } else {
            print("\nempty textFields\n")
            updateTextFieldsPlaceHolder(UIColor.redColor())
            // Shake effect or alert ?
        }
    }
    
    // MARK: Navigation 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DonorAccountInfo"{
            let accountInfoViewController = segue.destinationViewController as! DSAccountInfoViewController
            accountInfoViewController.donorSignupInfo = donorSignupInfo
        }
    }
    
    // MARK: Helper 
    
    func shouldTransition() ->Bool {
        guard let name = nameTextField.text,
            company = companyTextField.text,
            adress = adressTextField.text,
            phone = phoneTextField.text
            else { return false }
        
        if name.isBlank() { return false }
        if company.isBlank() { return false }
        if adress.isBlank() { return false }
        if phone.isBlank() { return false }
    
        return true
    }
    
    func delegateRegistration() {
        nameTextField.delegate = self
        companyTextField.delegate = self
        adressTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    func updateInfoStruct() {
        donorSignupInfo.name = nameTextField.text
        donorSignupInfo.company = companyTextField.text
        donorSignupInfo.adress = adressTextField.text
        donorSignupInfo.phone = phoneTextField.text
    }
    
    // MARK: UI 
    
    func updateTextFieldsPlaceHolder(color: UIColor){
        let textFields = [nameTextField, companyTextField, adressTextField, phoneTextField]
        for textField in textFields{
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: color])
        }
    }
    
}

extension DSUserInfoViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}

extension String{
    /// true if String is only white space
    func isBlank() -> Bool{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty
    }
}