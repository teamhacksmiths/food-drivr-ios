//
//  CurrentDonationsDashboard.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/22/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentDonationsDashboard: UIViewController {
    
    // action for unwind segue
    @IBAction func unwindForAccept(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    var activityIndicator : ActivityIndicatorView!
    private let dashboardPresenter = DashboardPresenter(donationService: DonationService())
    var pendingDonations: Results<Donation>?
    
    
    
    override func viewDidLoad() {
        self.title = "Current Donations"
        super.viewDidLoad()
        self.setupMenuBar()
        dashboardPresenter.attachView(self)
        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Syncing")
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PendingDonationsDashboard.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        dashboardPresenter.fetch([DonationStatus.Accepted.rawValue, DonationStatus.PickedUp.rawValue])
    }
    
    
    func refresh(sender: AnyObject) {
        self.startLoading()
        dashboardPresenter.fetchRemotely([DonationStatus.Accepted.rawValue, DonationStatus.PickedUp.rawValue])
        refreshControl?.endRefreshing()
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDriverMapDetailCurrentFromDashboard") {
            
            if let donation = sender as? Donation {
                let donationVC = segue.destinationViewController as! DriverMapDetailPendingVC
                
                donationVC.donation = donation
            }
        }
        
        if (segue.identifier == "acceptedDonation") {
            
            if let donation = sender as? Donation {
                let donationVC = segue.destinationViewController as! DriverMapPickupVC
                
                donationVC.donation = donation
            }
        }
        
    }
    

}

extension CurrentDonationsDashboard:  UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let cancel = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Cancel Donation" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let donation = self.pendingDonations![indexPath.row]
            self.activityIndicator.title = "Cancelling"
            self.dashboardPresenter.updateDonationStatus(donation, status: .Cancelled)
        })
        cancel.backgroundColor = UIColor.redColor()
        return [cancel]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingDonations?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "pendingDonation"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PendingDonationsDashboardTableViewCell
        cell.indexPath = indexPath
        cell.information = pendingDonations![indexPath.row]
        cell.addBorderTop(size: 1, color: UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1))
        
        
        return cell
    }
    

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toDriverMapDetailCurrentFromDashboard", sender: self)
    }
    
    //empty implementation
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension CurrentDonationsDashboard: DashboardView {
    
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.title = "Syncing"
    }
    
    func donations(sender: DashboardPresenter, didSucceed donations: Results<Donation>) {
        self.finishLoading()
        self.pendingDonations = donations
        self.tableView.reloadData()
    }
    
    func donations(sender: DashboardPresenter, didFail error: NSError) {
        self.finishLoading()
        if error.code == 401 {
            let refreshAlert = UIAlertController(title: "Unable To Sync.", message: "Your session has expired. Please log back in", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.logout()
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func donationStatusUpdate(sender: DashboardPresenter, didSucceed donation: Donation) {
        self.finishLoading()
        let index = pendingDonations!.indexOf(donation)
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func donationStatusUpdate(sender: DashboardPresenter, didFail error: NSError) {
        self.finishLoading()
        if error.code == 401 {
            let refreshAlert = UIAlertController(title: "Unable To Sync.", message: "Your session has expired. Please log back in", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.logout()
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        } else {
            let refreshAlert = UIAlertController(title: "Unable To Accept.", message: "Donation might have already been cancelled. Resync your donations?.", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.startLoading()
                self.dashboardPresenter.fetchRemotely([DonationStatus.Accepted.rawValue, DonationStatus.PickedUp.rawValue])
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        
    }
}
