//
//  SignUpNavigationViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class SignUpNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        configureNavigationBar()
    }
    
    // MARK: UI 
    
    func configureNavigationBar(){
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
        navigationBar.tintColor = UIColor.whiteColor()
    }
    
}