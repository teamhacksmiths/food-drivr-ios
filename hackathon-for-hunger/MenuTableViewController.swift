//
//  MenuTableViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/5/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit


class MenuTableViewController: UITableViewController {

    
    let user = User()
    
    let data = ["Dashboard", "Donations", "My Profile"]
    
    var menu = MenuManager.None

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        /* courtesy of stack overflow post: http://stackoverflow.com/questions/2339620/uitableview-add-content-offset-at-top*/
        self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        
        // check to see if user is a driver or donor and set color appropriateley
        switch user.id{
            case 0: view.backgroundColor = UIColor.orangeColor()
            case 1: view.backgroundColor = UIColor.blueColor()
            default: view.backgroundColor = UIColor.whiteColor()
        }
        
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
        switch user.id{
        case 0: cell.backgroundColor = UIColor.orangeColor()
        case 1: cell.backgroundColor = UIColor.blueColor()
        default: cell.backgroundColor = UIColor.whiteColor()
        
            
    }
        
                // Configure the cell...
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = MenuManager(rawValue: indexPath.item) {
            menu.navigation(self)
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

extension MenuTableViewController: MenuManagerDelegate {

    //Mark - delegate
    func menuManage(menuManager: MenuManager,changeMainViewController navigationController: UINavigationController){
        slideMenuController()?.changeMainViewController(navigationController, close: true)
    }
}



extension MenuTableViewController {
    
    
    //Mark - setting the height for the header and the footer
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150.0
    }
    
    //Mark - creat the view for the header and the footer
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(contentsOfFile: "")
        
        let stackView = UIStackView(arrangedSubviews: [logoImageView])
        stackView.alignment = .Center
        stackView.axis = .Vertical
        stackView.distribution = .Fill
        
        return stackView
        
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let logOutButton = UIButton()
        logOutButton.setTitle("LogOut", forState: .Normal)
        
        let stackView = UIStackView(arrangedSubviews: [logOutButton])
        stackView.alignment = .Center
        stackView.axis = .Vertical
        stackView.distribution = .Fill
        
        return stackView
    }
    
    
}




















