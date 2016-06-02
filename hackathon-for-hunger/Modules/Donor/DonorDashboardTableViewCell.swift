//
//  PendingDonationsDashboardTableViewCell.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 11/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonorDashboardTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deliveryDate: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var information: Donation? = nil {
        didSet {
            if let delivery = information?.dropoff?.actual {
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                formatter.timeStyle = .MediumStyle
                
                let dateString = formatter.stringFromDate(delivery)
                deliveryDate?.text = dateString
            }
            if let description = information?.donationItems.first?.type_description,
                quantity = information?.donationItems.first?.quantity,
                unit = information?.donationItems.first?.unit {
                amountLabel?.text = "\(quantity) \(unit) \(description)"
            } else {
                amountLabel?.text = "no donation items found"
            }
            statusLabel?.text = "\(information?.status.rawValue)"
        }
    }
}
