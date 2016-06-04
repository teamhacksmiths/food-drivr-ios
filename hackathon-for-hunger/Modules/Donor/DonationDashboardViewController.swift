//
//  DonorDonationViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 31/05/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import RealmSwift

class DonationDashboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDonationView: UIView!
    
    @IBAction func refreshButtonClicked(sender: AnyObject) {
        self.refresh(sender)
    }
    
    @IBOutlet weak var refreshButton: UIButton!
    
    var activityIndicator : ActivityIndicatorView!
    private let dashboardPresenter = DonationDashboardPresenter(donationService: DonationService())
    var pendingDonations: Results<Donation>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDonationView.hidden = true
        dashboardPresenter.attachView(self)
        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Syncing")
        self.refreshButton.layer.cornerRadius = 0.5 * self.refreshButton.bounds.width
        self.refreshButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.refreshButton.layer.shadowOffset = CGSizeMake(2, 2)
        self.refreshButton.layer.shadowRadius = 2
        self.refreshButton.layer.shadowOpacity = 0.5

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dashboardPresenter.fetch([])
    }
    
    func refresh(sender: AnyObject) {
        self.startLoading()
        dashboardPresenter.fetchRemotely([])
    }


}

extension DonationDashboardViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingDonations?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "donorDonation"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! DonorDashboardTableViewCell
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

extension DonationDashboardViewController: DonationDashboardView {
    
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        self.activityIndicator.stopAnimating()
    }
    
    func donations(sender: DonationDashboardPresenter, didSucceed donations: Results<Donation>) {
        self.finishLoading()
        self.pendingDonations = donations.sorted("rawStatus")
        if(donations.isEmpty) {
            self.tableView.hidden = true
            self.noDonationView.hidden = false
        } else {
            self.tableView.hidden = false
            self.noDonationView.hidden = true
            self.tableView.reloadData()
        }
        
    }
    
    func donations(sender: DonationDashboardPresenter, didFail error: NSError) {
        self.finishLoading()
        if error.code == 401 {
            let refreshAlert = UIAlertController(title: "Unable To Sync.", message: "Your session has expired. Please log back in", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.logout()
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func donationStatusUpdate(sender: DonationDashboardPresenter, didSucceed donation: Donation) {
        self.finishLoading()
        let index = pendingDonations!.indexOf(donation)
        self.performSegueWithIdentifier("acceptedDonation", sender: donation)
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func donationStatusUpdate(sender: DonationDashboardPresenter, didFail error: NSError) {
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
                self.dashboardPresenter.fetchRemotely([])
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        
    }
}
