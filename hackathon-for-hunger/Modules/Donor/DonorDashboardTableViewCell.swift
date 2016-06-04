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
            if let description = information?.donationItems.first?.type_description{
                amountLabel?.text = description
            } else {
                amountLabel?.text = "no donation items found"
            }
            if let status = information?.status {
                switch(status) {
                    
                case .Pending:
                    statusLabel?.text = "Pending"
                    break
                case .Accepted:
                    statusLabel?.text = "Accepted"
                    statusLabel?.textColor = UIColor(red: 31/255, green: 147/255, blue: 7/255, alpha: 1)
                    break
                case .Suspended:
                    statusLabel?.text = "Suspended"
                    break
                case .Cancelled:
                    statusLabel?.text = "Cancelled"
                    break
                case .PickedUp:
                    statusLabel?.text = "Picked Up"
                    break
                case .DroppedOff:
                    statusLabel?.text = "Dropped Off"
                    break
                case .Any:
                    statusLabel?.text = "Any"
                    break
                }

            }
            
        }
    }
}
