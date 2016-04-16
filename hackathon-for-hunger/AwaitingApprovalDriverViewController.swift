//
//  AwaitingApprovalDriverViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/7/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class AwaitingApprovalDriverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarButtons()
        hideBackButton()
        
//         var user = UserRegistration()
//         user.name = "test driver"
//         user.address = "address here"
//         user.phone = "015265926584"
//         user.email = "test@driver.com"
//         user.password = "testdriver"
//         user.password_confirmation = "testdriver"
//         user.role = .Donor
//        
//        DrivrAPI.sharedInstance.registerUser(user, success: {
//            (JsonDict) in
//            print (JsonDict)
//            }, failure: {
//                (error) in
//                print(error)
//        })
    }

    // MARK: UI 
    
    func addRightBarButtons(){
        navigationItem.rightBarButtonItem = doneButton()
    }
    
    func doneButton() -> UIBarButtonItem{
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(didPressDone))
    }
    
    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    // MARK: Navigation
    
    func didPressDone(){
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}