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
    
    
    @IBOutlet weak var fullNameLabel: UILabel?
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var deliveryDate: UILabel?
    
    weak var delegate: PendingDonationsDashboardTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationLabel?.adjustsFontSizeToFitWidth = true
    }
    
    var information: Donation? = nil {
        didSet {
            //print("Information: \(information?.donationItems)")
            if let delivery = information?.dropoff?.actual {
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                formatter.timeStyle = .MediumStyle
                
                let dateString = formatter.stringFromDate(delivery)
                deliveryDate?.text = dateString
            }
            
            fullNameLabel?.text = information?.recipient?.name
            if let desc = information?.donationItems.first?.type_description {
                amountLabel?.text = "\(desc)"
            } else {
                amountLabel?.text = "No description provided"
            }
//            if let description = information?.donationItems.first?.type_description,
//                    quantity = information?.donationItems.first?.quantity,
//                    unit = information?.donationItems.first?.unit {
//                amountLabel?.text = "\(quantity) \(unit) \(description)"
//            } else {
//                amountLabel?.text = "no donation items found"
//            }
            locationLabel?.text = information?.recipient?.street_address
        }
    }
    
    var indexPath: NSIndexPath?
    
    @IBAction func accept(sender: UIButton) {
        delegate?.cell(self, didPress: indexPath!)
    }
    
    
    
}