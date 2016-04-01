//
//  DashboardCollectionViewCell.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 31/03/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountOfFoodLabel: UILabel!
    
    
    func configure(information:(String,String,String) ) {
        
//        locationLabel.text = information.0
//        dateLabel.text = information.1
//        amountOfFoodLabel.text = information.2
//        
    }
    
    
}
