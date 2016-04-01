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
    var width: CGFloat!
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that cells take up 1 of the width,
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        width = floor(collectionView.frame.size.width)
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.collectionViewLayout = layout
    }
    
    
    
}


extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "informationCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DashboardCollectionViewCell
        
        let information = data[indexPath.row]
        cell.configure(information)
        return cell
        
    }
    
    
    
    
}