//
//  VSAccountInfoViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class VSAccountInfoViewController: UIViewController {
    
    // MARK: Actions
    
    @IBAction func didPressSignUp(sender: AnyObject) {
        let donorIsApproved = false
        if donorIsApproved{
            
        } else {
            showAwaitingApprovalView()
        }
    }
    
    // MARK: Navigation
    
    func showAwaitingApprovalView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let awaitingApprovalViewController = storyboard.instantiateViewControllerWithIdentifier("AwaitingApprovalDriverView") as! AwaitingApprovalDriverViewController
        navigationController?.pushViewController(awaitingApprovalViewController, animated: true)
    }
    
}