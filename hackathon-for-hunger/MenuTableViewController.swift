//
//  MenuTableViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/5/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit


class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let user = User()
    
    let data = ["Dashboard", "Donations", "My Profile"]
    
    var menu = MenuManager.None

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate  else {
            return
        }
        AuthProvider.sharedInstance.destroyUser()
        AuthProvider.sharedInstance.destroyToken()
        delegate.runLoginFlow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.separatorStyle = .None;
        /* courtesy of stack overflow post: http://stackoverflow.com/questions/2339620/uitableview-add-content-offset-at-top*/
        //self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        
        // check to see if user is a driver or donor and set color appropriateley
        switch user.id{
            case 0:
                view.backgroundColor = UIColor.orangeColor()
                tableView.backgroundColor = UIColor.orangeColor()
            case 1:
                view.backgroundColor = UIColor.blueColor()
                tableView.backgroundColor = UIColor.blueColor()
            default: view.backgroundColor = UIColor.whiteColor()
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel!.text = data[indexPath.row]
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.textLabel!.font.fontWithSize(18.0)
            cell.backgroundColor = UIColor.clearColor()
        
                // Configure the cell...
        return cell
    }
    

     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = MenuManager(rawValue: indexPath.item) {
            menu.navigation(self)
        }
    }
    
    deinit {
        print(#function, "\(self) deinitializing")
    }
   
}

extension MenuTableViewController: MenuManagerDelegate {

    //Mark - delegate
    func menuManage(menuManager: MenuManager,changeMainViewController navigationController: UINavigationController){
        slideMenuController()?.changeMainViewController(navigationController, close: true)
    }
}





















