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
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var addAddressButton: UIButton!
    
    var delegate: DonorAddressViewControllerDelegate?
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "ADD NEW ADDRESS"
        
        tabBarController?.tabBar.hidden = true
        
        addAddressButton.enabled = false
        addAddressButton.alpha = 0.5
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    // MARK: Helper methods
    
    func setupTextFields() {
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        
        addressTextField.addTarget(self, action: #selector(DonorAddAddressViewController.toggleButtonControl(_:)), forControlEvents: .AllEditingEvents)
        cityTextField.addTarget(self, action: #selector(DonorAddAddressViewController.toggleButtonControl(_:)), forControlEvents: .AllEditingEvents)
        stateTextField.addTarget(self, action: #selector(DonorAddAddressViewController.toggleButtonControl(_:)), forControlEvents: .AllEditingEvents)
        zipTextField.addTarget(self, action: #selector(DonorAddAddressViewController.toggleButtonControl(_:)), forControlEvents: .AllEditingEvents)
        
    }
    
    func toggleButtonControl(sender: UITextField) {
        guard
            let address = addressTextField.text where !address.isBlank,
            let city = cityTextField.text where !city.isBlank,
            let state = stateTextField.text where !state.isBlank,
            let zip = zipTextField.text where !zip.isBlank else {
                
                addAddressButton.enabled = false
                addAddressButton.alpha = 0.5
                return
        }
        addAddressButton.enabled = true
        addAddressButton.alpha = 1.0
    }
    
    func getAddressFromFields() -> String {
        // The add address button won't be enabled until all fields are filled
        // If reached here, we know the fields will have text
        return "\(addressTextField.text!), \(cityTextField.text!)"
    }
    
    // MARK: Actions
    
    
    @IBAction func didTapAddAddress(sender: AnyObject) {
        let address = getAddressFromFields()
        delegate?.addAddress(address)
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension DonorAddAddressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
