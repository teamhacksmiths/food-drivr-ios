//
//  ProfileViewController.swift
//  hackathon-for-hunger
//
//  Created by Anas Belkhadir on 15/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    

    private let userService: UserService = UserService()

 
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        print("Save pressed")
        updateUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuBar()
        self.title = "Profile"
        let currentUser = AuthService.sharedInstance.getCurrentUser()
        userNameTF.text = currentUser?.name
        emailTF.text = currentUser?.email


    }
    
    func updateUser() {
        
        
        var user = UserRegistration()
        user.email = emailTF.text ?? "donor@hacksmiths.com"
        user.phone = "3211231234"
        user.name = userNameTF.text ?? "please enter your name"
        user.password = "password"
        user.role = .Donor
        
        
        
        userService.updateUser(user).then() {
            updatedUser -> Void in
            print("USER::: \(updatedUser)")
            let userToUpdate = AuthService.sharedInstance.getCurrentUser()
            print("CURRENT USER: \(userToUpdate)")
            
        }
        
        
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}