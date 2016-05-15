//
//  MenuTableViewController.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 4/5/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit


class MenuTableViewController: UIViewController, UITableViewDelegate{
    
    
    let user = User()
    
    var  data: [String]? = nil
    
    
    
    private let menuPresenter = MenuPresenter(authService: AuthService())
    private var menuToDisplay = [Int: Menu]()
    
    private var cacheVC: [NSIndexPath: UIViewController] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        self.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.separatorStyle = .None;
        /* courtesy of stack overflow post: http://stackoverflow.com/questions/2339620/uitableview-add-content-offset-at-top*/
        //self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        
        view.backgroundColor = UIColor(red: 77/255, green: 57/255, blue: 75/255, alpha: 1)
        tableView.backgroundColor = UIColor(red: 77/255, green: 57/255, blue: 75/255, alpha: 1)
        // check to see if user is a driver or donor and set color appropriateley
        
        //SetUp menu based on type of user
        menuPresenter.attachView(self)
        menuPresenter.getMenuItems()
        
        //create menu based on type user
        //        typeUser.createMenu(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let vc = cacheVC[indexPath] {
            slideMenuController()?.changeMainViewController(vc, close: true)
        }else{
            let identifier = menuToDisplay[indexPath.row]!.identifier
            let vc = storyboard?.instantiateViewControllerWithIdentifier(identifier)
            cacheVC[indexPath] = vc
            slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: vc!), close: true)
        }
    }
    
    deinit {
        print(#function, "\(self) deinitializing")
    }
    
}


extension MenuTableViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuToDisplay.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = menuToDisplay[indexPath.row]!.itemName
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font.fontWithSize(18.0)
        cell.backgroundColor = UIColor.clearColor()
        cell.addBorderBottom(size: 1, color: UIColor.whiteColor().colorWithAlphaComponent(0.5))
        
        // Configure the cell...
        return cell
    }
    
}

extension MenuTableViewController: MenuView{
    
    func setMenuItems(menuItems: [Int: Menu]){
        menuToDisplay = menuItems
    }
    
}