//
//  DonationsOverviewViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/17/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonationsContainerViewController: UIViewController {

    enum ActiveBoard : Int {
        case List
        case Map
    }
    
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var dashboardContainerView: UIView!
    weak var currentViewController: UIViewController?
    var donationListView: PendingDonationsDashboard?
    var donationOverviewMap: DonationMapOverviewVC?
    var currentActiveView: ActiveBoard = .List
    
    override func viewDidLoad() {
        self.setupMenuBar()
        self.setupView()
        super.viewDidLoad()
    }
    
    private func setupView() {
        self.title = AuthService.sharedInstance.getCurrentUser()?.name ?? "Pending Donations"
        
        self.donationListView = self.storyboard?.instantiateViewControllerWithIdentifier("DonationLIstView") as? PendingDonationsDashboard
        self.currentViewController = self.donationListView
        self.toggleButton.layer.cornerRadius = 0.5 * self.toggleButton.bounds.width
        self.toggleButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.toggleButton.layer.shadowOffset = CGSizeMake(2, 2)
        self.toggleButton.layer.shadowRadius = 2
        self.toggleButton.layer.shadowOpacity = 0.5
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.dashboardContainerView)

    }
    
    @IBAction func containerButtonToggled(sender: AnyObject) {
        
        switch currentActiveView {
        case .Map:
            
            self.currentActiveView = .List
            let newViewController = self.donationListView
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.toggleButton.setImage(UIImage(named: "map-icon"), forState: .Normal)
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
            
        case .List:
            
            self.currentActiveView = .Map
            if let newViewController = self.donationOverviewMap {
                newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                self.toggleButton.setImage(UIImage(named: "list-icon"), forState: .Normal)
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController)
            } else {
                 self.toggleButton.setImage(UIImage(named: "list-icon"), forState: .Normal)
                self.donationOverviewMap = self.storyboard?.instantiateViewControllerWithIdentifier("DonationOverviewMap") as? DonationMapOverviewVC
                let newViewController = self.donationOverviewMap
                newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            }

        }
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        self.currentViewController = newViewController
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.dashboardContainerView!)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
        
        // TODO: Set the ending state of your constraints here
        
        UIView.animateWithDuration(0.5, animations: {
            // only need to call layoutIfNeeded here
            newViewController.view.layoutIfNeeded()
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMoveToParentViewController(self)
        })
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate  else {
            return
        }
        delegate.runLoginFlow()
    }
}