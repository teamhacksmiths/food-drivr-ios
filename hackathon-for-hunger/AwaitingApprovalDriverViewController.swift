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