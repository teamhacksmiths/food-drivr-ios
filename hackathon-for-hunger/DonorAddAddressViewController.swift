//
//  DonorAddAddressViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/30/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonorAddAddressViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    var delegate: DonorAddressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressTextField.delegate = self
    }
    
    // MARK: Actions 
    
    
    @IBAction func didTapAddAddress(sender: AnyObject) {
        if let address = addressTextField.text{
            if !address.isBlank{
                delegate?.addAddress(address)
                navigationController?.popViewControllerAnimated(true)
            } else {
                print("blank entry")
            }
        }
    }
    
}

extension DonorAddAddressViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
