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
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let information = "informationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(information, forIndexPath: indexPath) as! DashboardViewCell
        cell.information = data[indexPath.row]
        
        return cell
    }
    
}
