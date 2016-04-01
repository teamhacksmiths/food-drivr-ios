//
//  DashboardViewCell.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 01/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DashboardViewCell: UITableViewCell {
    
  
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var information: (String,String,String)? = nil {
        didSet {
            
            locationLabel.text = information!.0
            amountLabel.text = information!.1
            dateLabel.text = information!.2
            
        }
    }
    
}