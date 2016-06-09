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
    var addresses = [String]()
    var defaultAddressIndex:NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
                
        navigationController?.navigationBar.barTintColor = UIColor(red: 247/255.0, green: 179/255.0, blue: 43/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        self.parentViewController?.preferredStatusBarStyle()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reusableIdentifier, forIndexPath: indexPath) as! DonorAddressCell
        
        var isDefault = false
        if indexPath == defaultAddressIndex || addresses.count == 1 {
            isDefault = true
        }
        cell.configureCell(addresses[indexPath.row], defaultAddress: isDefault)
        
        return cell
    }
    
    // MARK: Data Source Helper 
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath){
        cell.textLabel?.text = addresses[indexPath.row]
        cell.accessoryType = .None
        if defaultAddressIndex == indexPath{
            cell.accessoryType = .Checkmark
        }
        if addresses.count == 1 {
            cell.accessoryType = .Checkmark
            defaultAddressIndex = indexPath
        }
    }
    
}

extension DonorAddressViewController: UITableViewDelegate{
    
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
