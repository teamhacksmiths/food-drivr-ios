//
//  DashboardViewController.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 31/03/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//


import UIKit

class DashboardViewController: UICollectionViewController,  DashboardLayoutDelegate  {
    
    
    let data : [(String, String, String)] = [("kenitra", "10", "4 egges"),
                ("Rabat", "1994", "5" ),
    ]
    
    
    //Inforamtion about the current user
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var deliveriesLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = CGRectGetWidth(collectionView!.bounds) / 2
        let layout =  collectionViewLayout as! DashboardLayout
        layout.delegate = self
        layout.numberOfColumns = 1
    }
    
    
    
}



extension DashboardViewController{
    
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    
}














