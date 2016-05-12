//
//  MenuManager.swift
//  
//
//  Created by Anas Belkhadir on 15/04/2016.
//
//

import UIKit
import CoreLocation


protocol MenuView: NSObjectProtocol {
    func setMenuItems(menuItems: [Int: Menu])
}



struct Menu {
    let itemName: String
    let identifier: String
}

class MenuPresenter {
    private let authService : AuthService
    weak private var menuView: MenuView?
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func attachView(view: MenuView){
        menuView = view
    }
    
    func detachView() {
        menuView = nil
    }
    
    func getMenuItems() {
        
        let role =  AuthService.sharedInstance.getCurrentUser()!.role
        
        switch role {
        case 0 :
            let menu = [ 0: Menu(itemName: "Pending Donations", identifier: "Main"),
                         1: Menu(itemName: "Current Donations", identifier: "CurrentDonationLIstView"),
                         2: Menu(itemName: "Donation History", identifier: "CurrentDonationLIstView"),
                         3: Menu(itemName: "My Profile", identifier: "ProfileViewController")
            ]
            menuView?.setMenuItems(menu)
        case 1:
            let menu = [ 0: Menu(itemName: "Dashboard", identifier: "Main"),
                         1: Menu(itemName: "Donations", identifier: "CurrentDonationLIstView"),
                         2: Menu(itemName: "Addresses", identifier: "CurrentDonationLIstView"),
                         3: Menu(itemName: "My Profile", identifier: "ProfileViewController")
            ]
            menuView?.setMenuItems(menu)
        default :
            break
        }
        
    }
    
}
