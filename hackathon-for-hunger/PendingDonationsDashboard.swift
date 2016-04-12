//
//  PendingDonationsDashboard.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 11/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class PendingDonationsDashboard: UITableViewController {
    
    
    var mockData = [("baba","baba","baba"),
                    ("prapra","prapra","prapra")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    
    
    //Mark - Create the HeaderView to our tableView
    lazy var containerView: UIView = {
        
        let placeHolderImage = UIImageView()
        let fullName = UILabel()
        fullName.text = "PENDING DONATION"
        
        
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
}



extension PendingDonationsDashboard: PendingDonationsDashboardTableViewCellDelegate {
    
    func cell(cell: PendingDonationsDashboardTableViewCell, didPress indexPath: NSIndexPath) {
        mockData.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

}









