//
//  DonationsOverviewViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/17/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonationsOverviewViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var dashboardContainerView: UIView!
    let viewControllerIdentifiers = ["DonationLIstView", "DonationOverviewMap"] 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBar()
        self.updateContainers(0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func setupMenuBar() {
        self.navigationController?.navigationBar.translucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let menuBtn = UIButton()
        menuBtn.setImage(UIImage(named: "burger"), forState: .Normal)
        menuBtn.frame = CGRectMake(0, 0, 30, 30)
        menuBtn.addTarget(self, action: #selector(UIViewController.toggleMenu), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "ian gristock"
    }
    
    func toggleMenu() {
        self.slideMenuController()?.openLeft()
    }
}