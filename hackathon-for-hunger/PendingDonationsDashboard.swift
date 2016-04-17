//
//  PendingDonationsDashboard.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 11/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit
import RealmSwift

class PendingDonationsDashboard: UITableViewController {
    
    
    var mockData = [("baba","baba","baba"),
                    ("prapra","prapra","prapra")]
    var donations: Results<Donation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DrivrAPI.sharedInstance.getDonations(success: {
//                (results) in
//                print(results)
//            }, failure: {
//                (error) in
//                print(error)
//        })
    }
    

    
    
    
    //Mark - Create the HeaderView to our tableView
    lazy var containerView: UIView = {
        
        let placeHolderImage = UIImageView()
        placeHolderImage.translatesAutoresizingMaskIntoConstraints = true
        placeHolderImage.image = UIImage(imageLiteral: "personHolder")
        
        NSLayoutConstraint(item: placeHolderImage, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100.0).active = true
        NSLayoutConstraint(item: placeHolderImage, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100.0).active = true
        
        let fullName = UILabel()
        fullName.text = "PENDING DONATION"
        fullName.textColor = UIColor.grayColor()
        
        let containerStackView = UIStackView(arrangedSubviews: [placeHolderImage, fullName])
        containerStackView.axis = .Vertical
        containerStackView.spacing = 10.0
        containerStackView.alignment = .Center
        containerStackView.distribution = .EqualCentering
        
        return containerStackView
    }()
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return containerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140.0
    }
    
    //Mark - Setting up tableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "pendingDonation"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! PendingDonationsDashboardTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.information = mockData[indexPath.row]
        
        return cell
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








