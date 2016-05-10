//
//  MenuManager.swift
//  
//
//  Created by Anas Belkhadir on 15/04/2016.
//
//

import UIKit
import CoreLocation

protocol TypeUserDelegate {
    func typeUser(pickUpTypeUser typeUser: TypeUser) -> TypeUser?
    func typeUser(typeUser: TypeUser, sendMenuData data: [String])
}

protocol MenuManagerDelegate {
    func menuManage(menuManager: MenuManager,changeMainViewController navigationController: UINavigationController)

}

protocol Menu {
    var storyboard: UIStoryboard { get set }
    var navigationController: UINavigationController { get set }
    func navigation(delegate: MenuManagerDelegate)
    
}

enum TypeUser {
    //data contain 
    case Donor
    case Driver
    case None
    
    static private var menuData: [String]? = nil
    
    func createMenu(delegate: TypeUserDelegate) {
        let typeUser = delegate.typeUser(pickUpTypeUser: self)!
        switch typeUser {
        case .Donor:
            TypeUser.menuData = ["Pending Donations", "Current Donations", "Donation History", "My Profile"]
            delegate.typeUser(self, sendMenuData: TypeUser.menuData!)
        case .Driver:
            TypeUser.menuData = ["Dashboard", "Donations", "Addresses", "My Profile"]
            delegate.typeUser(self, sendMenuData: TypeUser.menuData!)
        case .None:
            break
        }
    }
    
}




enum MenuManager: Int {
    

    case PendingDonations = 0
    case CurrentDonations
    case DonationHistory
    case Profile
    case None

    case Dashboard
    case Donations
    case MyProfile
    case Addresses

    func navigation(delegate: MenuManagerDelegate) {
        createNavigationControllerForDonor()
        delegate.menuManage(self, changeMainViewController: MenuManager.navigationController!)
        
    }
    
    
    private struct Identifier {
        static let pendingDonationsIdentifier = "Main"
        static let currentDonationsIdentifier = "CurrentDonationLIstView"
        static let profileIdentifier = "ProfileViewController"
    }
    
    static private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    static private var navigationController: UINavigationController? = nil
    
    
    private func createNavigationControllerForDonor() {
        switch self {
            case .PendingDonations:
                let dashboardVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.pendingDonationsIdentifier)
                                            as! DonationsContainerViewController
                MenuManager.navigationController = UINavigationController(rootViewController: dashboardVC)
            
            case .CurrentDonations:
                let donationOverVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.currentDonationsIdentifier)
                    as! CurrentDonationsDashboard
                MenuManager.navigationController = UINavigationController(rootViewController: donationOverVC)
            
        case .DonationHistory:
            let profileVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.currentDonationsIdentifier)
                as! CurrentDonationsDashboard
            MenuManager.navigationController = UINavigationController(rootViewController: profileVC)
            
            case .Profile:
                let profileVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.profileIdentifier)
                    as! ProfileViewController
                MenuManager.navigationController = UINavigationController(rootViewController: profileVC)
            
            case None:
                break
        default:break
        }
        
    }
    private func createNavigationControllerForDriver(){
        switch self {
        case .Dashboard:
            break
        case .Donations:
            break
        case .MyProfile:
            break
        case .Addresses:
            break
        case .None:
            break
        default:break
        }
    }
    
}




//