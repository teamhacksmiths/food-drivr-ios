//
//  DashboardViewController.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 31/03/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//


import UIKit

class DashboardViewController: UIViewController {
    
    
    let data : [(String, String, String)] = [("kenitra", "10", "4 egges"),
                ("Rabat", "1994", "5" ),
    ]
    
    
    //Inforamtion about the current user
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var deliveriesLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    
    
    //Mark - CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    //the width of collectionViewCell

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
}


//extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    
//
//    
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        let reuseIdentifier = "informationCell"
//        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DashboardCollectionViewCell
//        
//        let information = data[indexPath.row]
//        cell.configure(information)
//        return cell
//        
//    }
//    
//    
//    
//    
//}

extension DashboardViewController: DashboardLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    
}














