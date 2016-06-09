//
//  DonorAddressCell.swift
//  hackathon-for-hunger
//
//  Created by Mikael Mukhsikaroyan on 6/9/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonorAddressCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(address: String, defaultAddress: Bool) {
        if defaultAddress {
            addressLabel.font = UIFont(name: "OpenSans-Bold", size: 20)
            checkmarkImage.image = UIImage(named: "check_mark")
        } else {
            addressLabel.font = UIFont(name: "OpenSans", size: 20)
            checkmarkImage.image = nil 
        }
        addressLabel.text = address 
    }
    
}
