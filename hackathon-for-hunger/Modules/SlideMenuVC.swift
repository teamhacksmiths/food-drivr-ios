//
//  SlideMenuVC.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 15/05/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideMenuVC: SlideMenuController {
    
    
    override func awakeFromNib() {
        let mainVc = self.storyboard!.instantiateViewControllerWithIdentifier("Main") as! DonationsContainerViewController
        let leftVc = self.storyboard!.instantiateViewControllerWithIdentifier("Left") as! MenuTableViewController
        self.mainViewController = UINavigationController(rootViewController: mainVc)
        self.leftViewController = leftVc
        self.addLeftBarButtonWithImage(UIImage(named:"hamburger")!)
        super.awakeFromNib()
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        print("HERE")
    }
}