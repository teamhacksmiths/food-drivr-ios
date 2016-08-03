//
//  DonorAddressTableViewCell.swift
//  hackathon-for-hunger
//
//  Created by Mikael Mukhsikaroyan on 6/9/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonorAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(address: Address) {
        if address.isDefault {
            addressLabel.font = UIFont(name: "OpenSans-Bold", size: 20)
            checkmarkImage.image = UIImage(named: "check_mark")
        } else {
            addressLabel.font = UIFont(name: "OpenSans", size: 20)
            checkmarkImage.image = nil
        }
        if let address = address.street_address {
            addressLabel.text = address
        } else {
            addressLabel.text = "No street address provided"
        }
    }

}
