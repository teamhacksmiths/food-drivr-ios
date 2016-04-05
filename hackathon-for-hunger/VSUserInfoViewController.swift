//
//  VSUserInfoViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/4/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class VSUserInfoViewController: UIViewController {
    
    // MARK: Actions 
    
    @IBAction func didPressNext(sender: UIButton) {
        performSegueWithIdentifier("VolunteerAccountInfo", sender: nil)
    }
    
}