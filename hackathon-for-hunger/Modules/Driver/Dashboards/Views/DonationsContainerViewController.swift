//
//  DonationsOverviewViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/17/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonationsContainerViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentBackground: UIView!
    @IBOutlet weak var dashboardContainerView: UIView!
    let viewControllerIdentifiers = ["DonationLIstView", "DonationOverviewMap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBar()
        self.title = AuthProvider.sharedInstance.getCurrentUser()?.name ?? "Pending Donations"
        self.updateContainers(0)
        segmentBackground.addBorderTop(size: 1, color: UIColor.grayColor())
        segmentedControl.frame = CGRect(x: segmentedControl.frame.origin.x, y: segmentedControl.frame.origin.y, width: segmentedControl.frame.size.width, height: 64);
        segmentedControl.removeBorders()
    }
    
    @IBAction func segmentedControlUpdated(sender: AnyObject) {
        self.updateContainers(sender.selectedSegmentIndex)
    }
    
    func updateContainers(index: Int) {
        let newController = (storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifiers[index]))! as UIViewController
        let oldController = childViewControllers.last! as UIViewController
        
        oldController.willMoveToParentViewController(nil)
        addChildViewController(newController)
        newController.view.frame = oldController.view.frame
        
        transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
            // nothing needed here
            }, completion: { (finished) -> Void in
                oldController.removeFromParentViewController()
                newController.didMoveToParentViewController(self)
        })
    }
}