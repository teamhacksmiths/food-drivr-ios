//
//  DashboardViewController.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 31/03/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//


import UIKit

class DashboardViewController: UIViewController {
    
    
    let data : [(String, String, String)] = [("kenitra", "10", "4 eggs"),
                ("Rabat", "1994", "5" ),
    ]
    
    
    //Inforamtion about the current user
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var deliveriesLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 20/255, green: 207/255, blue: 232/255, alpha: 1)

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
