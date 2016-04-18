//
//  PendingDonationsDashboard.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 11/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import RealmSwift

class PendingDonationsDashboard: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var realm = try! Realm()
    var donations: Results<Donation>?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDonations()
    }
    
    //Mark - Setting up tableView
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations?.count ?? 0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "pendingDonation"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PendingDonationsDashboardTableViewCell
        cell.indexPath = indexPath
        cell.information = donations![indexPath.row]
        if indexPath.row == 0 {
            cell.addBorderTop(size: 1, color: UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1))
        }
        cell.addBorderBottom(size: 1, color: UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1))
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let accept = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Accept Donation" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //go to accept donation
        })
        accept.backgroundColor = UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1)
        
        
        return [accept]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toDriverMapDetailPendingFromDashboard", sender: donations![indexPath.row])
    }
    
    //empty implementation
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    func getDonations() {
        let pendingDonations = realm.objects(Donation)
        guard pendingDonations.count > 0 else {
            self.fetchRemoteDonations()
            return
        }
        self.donations = pendingDonations
        self.tableView.reloadData()
    }
    
    private func fetchRemoteDonations() {
        DrivrAPI.sharedInstance.getDonations(success: {
            (results) in
            self.donations = results
            self.tableView.reloadData()
            }, failure: {
                (error) in
                print(error)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDriverMapDetailPendingFromDashboard") {
            
            if let donation = sender as? Donation {
                let donationVC = segue.destinationViewController as! DriverMapDetailPendingVC
                
                donationVC.donation = donation
            }
        }
    }
}








