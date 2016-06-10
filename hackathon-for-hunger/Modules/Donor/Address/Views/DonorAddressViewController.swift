//
//  DonorAddressViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/30/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

protocol DonorAddressViewControllerDelegate {
    func addAddress(address:String)
}

class DonorAddressViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let reusableIdentifier = "DonorAddressCell"
    let addAddressSegueIdentifier = "AddAddress"
    let authService = AuthService()
    var addresses = [String]()
    var defaultAddressIndex:NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        showUserOrganisationTitle()
        setupNavAppearance()
    }
    
    // MARK: Helper methods
    
    func setupNavAppearance() {
        navigationController?.navigationBar.translucent = false 
        navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 165/255.0, blue: 4/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    
    func showUserOrganisationTitle() {
        if let currentUser = authService.getCurrentUser() {
            if let userOrg = currentUser["organisation"] as? String {
                title = userOrg
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func didTapAddAddress(sender: AnyObject) {
        shouldPerformSegueWithIdentifier(reusableIdentifier, sender: nil)
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! DonorAddAddressViewController).delegate = self
    }
    
}

extension DonorAddressViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reusableIdentifier, forIndexPath: indexPath) as! DonorAddressTableViewCell
        
        var isDefault = false
        if indexPath == defaultAddressIndex || addresses.count == 1 {
            isDefault = true
        }
        cell.configureCell(addresses[indexPath.row], defaultAddress: isDefault)
        
        return cell
    }
    
}

extension DonorAddressViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75 
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defaultAddressIndex = indexPath
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            addresses.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        if indexPath == defaultAddressIndex{
            defaultAddressIndex = nil
        }
    }
    
}

extension DonorAddressViewController: DonorAddressViewControllerDelegate{
    func addAddress(address: String) {
        self.addresses.append(address)
        tableView.reloadData()
    }
}
