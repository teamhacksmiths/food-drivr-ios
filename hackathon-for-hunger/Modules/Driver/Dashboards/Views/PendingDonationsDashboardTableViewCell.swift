//
//  PendingDonationsDashboardTableViewCell.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 11/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

protocol PendingDonationsDashboardTableViewCellDelegate: class {
    
    func cell(cell: PendingDonationsDashboardTableViewCell, didPress indexPath: NSIndexPath)
}


class PendingDonationsDashboardTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    weak var delegate: PendingDonationsDashboardTableViewCellDelegate?
    

    
    var information: Donation? = nil {
        didSet {
            fullNameLabel.text = information?.recipient?.name
            if let description = information?.donationItems.first?.type_description,
                    quantity = information?.donationItems.first?.quantity,
                    unit = information?.donationItems.first?.unit {
                amountLabel.text = "\(quantity) \(unit) \(description)"
            } else {
                amountLabel.text = "no donation items found"
            }
            locationLabel.text = information?.recipient?.street_address
        }
    }
    
    var indexPath: NSIndexPath?
    
    @IBAction func accept(sender: UIButton) {
        delegate?.cell(self, didPress: indexPath!)
    }
    
    
    
}