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
        
         var user = RegistrationDTO()
         user.name = "test user one"
         user.address = "8 Redstone Way, Whiston Liverpool L35 7NZ"
         user.phone = "015265926584"
         user.email = "iangristock@gmail.com"
         user.password = "r0089890"
         user.role = .Donor
        
        DrivrAPI.sharedInstance.registerUser(user, success: {
            (JsonDict) in
            print (JsonDict)
            }, failure: {
                (error) in
                print(error)
        })
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