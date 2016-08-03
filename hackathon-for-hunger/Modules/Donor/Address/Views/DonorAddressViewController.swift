//
//  DonorAddressViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/30/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import RealmSwift

protocol DonorAddressViewControllerDelegate {
    func addAddress(address:Address)
}

class DonorAddressViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let reusableIdentifier = "DonorAddressCell"
    let addAddressSegueIdentifier = "AddAddress"
    let authService = AuthService()
    var addresses = [Address]()
    let userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm path: \(Realm.Configuration.defaultConfiguration.fileURL)")
        tableView.dataSource = self
        tableView.delegate = self
        
        showUserOrganisationTitle()
        getDonorAddresses()
        setupNavAppearance()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    func getDonorAddresses() {
        if let currentUser = authService.getCurrentUser() {
            if let userAddresses = currentUser["addresses"] as? List<Address> {
                print("Donor Addresses Count: \(userAddresses.count)")
                for address in userAddresses {
                    //print("Address: \(address)")
                    addresses.append(address)
                }
            } else {
                print("No donor addresses")
            }
            print("User: \(currentUser)")
        }
    }
    
    func showUserOrganisationTitle() {
        if let currentUser = authService.getCurrentUser() {
            if let userOrg = currentUser["organisation"] as? String {
                title = userOrg
            }
        }
    }
    
    func updateAddresses() {
        //print(addresses.count)
        let updateData = UserUpdate(name: nil, phone: nil, email: nil, password: nil, password_confirmation: nil, avatar: nil, address: addresses)
        userService.updateUser(updateData).then { userDict -> Void in
            print("User info uploaded: \(userDict)")
            self.tableView.reloadData()
            }.error { error in
                print("Error uploading: \(error)")
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
        
        cell.configureCell(addresses[indexPath.row])
        
        return cell
    }
    
}

extension DonorAddressViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75 
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        SweetAlert().showAlert("Update Default Address?", subTitle: "Are you sure you want to change your default address?", style: AlertStyle.Warning, buttonTitle: "Yes", buttonColor: UIColor.blueColor(), otherButtonTitle: "No") { (isOtherButton) in
            if isOtherButton {
                // Yes tapped
                for i in 0..<self.addresses.count {
                    do {
                        try self.realm.write({ 
                            if i == indexPath.row {
                                self.addresses[i].isDefault = true
                            } else {
                                self.addresses[i].isDefault = false
                            }
                        })
                    } catch let error as NSError {
                        print("Error writing to Realm: \(error.localizedDescription)")
                    }

                }
                self.updateAddresses()
                tableView.reloadData()
            } else {
                // No tapped 
            }
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            addresses.removeAtIndex(indexPath.row)
            print("Removed: \(addresses)")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            updateAddresses()
        }
    }
    
}

extension DonorAddressViewController: DonorAddressViewControllerDelegate{
    func addAddress(address: Address) {
        addresses.append(address)
        if addresses.count == 1 {
            addresses[0].isDefault = true
        }
        updateAddresses()
    }
}
