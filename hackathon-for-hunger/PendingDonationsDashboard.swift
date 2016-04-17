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
    
    
    var mockData = [("EINSTEINS BAGELS","3 dozen bagels","933 jaquan Lock, Portland"),
                    ("CHEZ HEY","5 dozen bagels","933 hope street, Portland")]
    var donations: Results<Donation>?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DrivrAPI.sharedInstance.getDonations(success: {
                (results) in
                self.donations = results
            self.tableView.reloadData()
            }, failure: {
                (error) in
                print(error)
        })
    }
    
    //Mark - Setting up tableView
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations?.count ?? 0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "pendingDonation"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PendingDonationsDashboardTableViewCell
        cell.delegate = self
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
    
    //empty implementation
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}

extension PendingDonationsDashboard: PendingDonationsDashboardTableViewCellDelegate {
    
    func cell(cell: PendingDonationsDashboardTableViewCell, didPress indexPath: NSIndexPath) {
        mockData.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

}








