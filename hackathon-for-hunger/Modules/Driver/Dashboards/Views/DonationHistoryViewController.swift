//
//  DonationHistoryViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 20/05/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import RealmSwift

class DonationHistoryViewController: UIViewController {
    
    @IBOutlet weak var noDonationsView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    var activityIndicator : ActivityIndicatorView!
    private let dashboardPresenter = DashboardPresenter(donationService: DonationService())
    var pendingDonations: Results<Donation>?
    
    
    
    @IBOutlet weak var refreshTriggered: UIButton!
    @IBAction func refreshDonations(sender: AnyObject) {
        self.refresh(self)
    }
    
    override func viewDidLoad() {
        self.refreshTriggered.layer.cornerRadius = 0.5 * self.refreshTriggered.bounds.width
        self.refreshTriggered.layer.shadowColor = UIColor.blackColor().CGColor
        self.refreshTriggered.layer.shadowOffset = CGSizeMake(2, 2)
        self.refreshTriggered.layer.shadowRadius = 2
        self.refreshTriggered.layer.shadowOpacity = 0.5

        super.viewDidLoad()
        noDonationsView.hidden = true
        dashboardPresenter.attachView(self)
        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Syncing")
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PendingDonationsDashboard.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dashboardPresenter.fetch([DonationStatus.DroppedOff.rawValue, DonationStatus.Suspended.rawValue ])
    }
    
    func refresh(sender: AnyObject) {
        self.startLoading()
        dashboardPresenter.fetchRemotely([DonationStatus.DroppedOff.rawValue, DonationStatus.Suspended.rawValue])
        refreshControl?.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDriverMapDetailPendingFromDashboard") {
            
            if let donation = sender as? Donation {
                let donationVC = segue.destinationViewController as! DriverMapDetailPendingVC
                donationVC.mapViewPresenter = MapViewPresenter(donationService: DonationService(), donation: donation)
            }
        }
        
        if (segue.identifier == "acceptedDonation") {
            
            if let donation = sender as? Donation {
                let donationVC = segue.destinationViewController as! DriverMapPickupVC
                
                donationVC.donation = donation
            }
        }
        
    }
    
    deinit {
        print("DEINITIALIZING")
    }
}

extension DonationHistoryViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingDonations?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "pendingDonation"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PendingDonationsDashboardTableViewCell
        cell.indexPath = indexPath
        cell.information = pendingDonations![indexPath.row]
        cell.selectionStyle = .None;
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}

extension DonationHistoryViewController: DashboardView {
    
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
        if(donations.isEmpty) {
            self.tableView.hidden = true
            self.noDonationsView.hidden = false
        } else {
            self.tableView.hidden = false
            self.noDonationsView.hidden = true
            self.tableView.reloadData()
        }
        
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
        self.performSegueWithIdentifier("acceptedDonation", sender: donation)
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
            let refreshAlert = UIAlertController(title: "Unable To Accept.", message: "Donation might have already been accepted. Resync your donations?.", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.startLoading()
                self.dashboardPresenter.fetchRemotely([DonationStatus.Pending.rawValue])
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        
    }
}
