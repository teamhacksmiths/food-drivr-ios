//
//  MenuTableViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/5/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case Dashboard = 0
    case DonationsOverview
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class MenuTableViewController: UITableViewController {

    let data = ["Dashboard", "Donations", "Menu Item 3", "Menu Item 4", "Menu Item 5", "Menu Item 6"]
    
    var dashboardController: UIViewController!
    var donationMapOverview: UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardController = storyboard.instantiateViewControllerWithIdentifier("Main") as! PendingDonationsDashboard
        self.dashboardController = UINavigationController(rootViewController: dashboardController)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let donationMapOverview = storyboard.instantiateViewControllerWithIdentifier("DonationOverviewMap") as! DonationMapOverviewVC
        self.donationMapOverview = UINavigationController(rootViewController: donationMapOverview)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel!.text = data[indexPath.row]
        // Configure the cell...
        return cell
    }
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Dashboard:
            self.slideMenuController()?.changeMainViewController(self.dashboardController, close: true)
        case .DonationsOverview:
            self.slideMenuController()?.changeMainViewController(self.donationMapOverview, close: true)
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
