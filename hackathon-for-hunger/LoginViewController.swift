//
//  LoginViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("")
        DrivrAPI.sharedInstance.getDonations(dateRange: "test", completionHandler: {
            response, error in
            print(response)
            print(error)
        })
    }



}

