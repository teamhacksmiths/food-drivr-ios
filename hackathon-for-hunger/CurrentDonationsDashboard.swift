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
    
    var realm = try! Realm()
    var donationVM: DonationViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth=1.0
        imageView.layer.borderColor = UIColor.blackColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
        donationVM = DonationViewModel()
        donationVM.delegate = self
        donationVM.fetch(.Active)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PendingDonationsDashboard.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    func refresh(sender: AnyObject) {
        
        donationVM.fetchRemotely(.Active)
        refreshControl?.endRefreshing()
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDriverMapDetailPendingFromDashboard") {
            
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
            let donation = self.donationVM.donationAtIndex(indexPath.row)
            self.donationVM.updateDonationStatus(donation, status: .Active)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        cancel.backgroundColor = UIColor.redColor()
        return [cancel]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationVM.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "pendingDonation"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PendingDonationsDashboardTableViewCell
        cell.indexPath = indexPath
        cell.information = donationVM.donationAtIndex(indexPath.row)
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
        self.performSegueWithIdentifier("toDriverMapDetailPendingFromDashboard", sender: donationVM.donationAtIndex(indexPath.row))
    }
    
    //empty implementation
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}
extension CurrentDonationsDashboard: DonationDelegate {
    
    func donationViewModel(sender: DonationViewModel, didSucceed donations: Results<Donation>) {
        self.tableView.reloadData()
    }
    func donationViewModel(sender: DonationViewModel, didFail error: NSError) {
        
    }
}
