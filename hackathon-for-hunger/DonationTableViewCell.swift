//
//  DonationTableViewCell.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

protocol DonationCellDelegate{
    func didTapCancel(cell: DonationTableViewCell)
}

class DonationTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    var delegate: DonationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    // MARK: Actions 
    
    @IBAction func didTapCancel(sender: AnyObject) {
        delegate?.didTapCancel(self)
    }
    
}
