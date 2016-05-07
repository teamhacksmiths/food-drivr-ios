//
//  MenuManager.swift
//  
//
//  Created by Anas Belkhadir on 15/04/2016.
//
//

import UIKit
import CoreLocation


protocol MenuManagerDelegate {
    func menuManage(menuManager: MenuManager,changeMainViewController navigationController: UINavigationController)
}


enum MenuManager: Int {
    
    case PendingDonations = 0
    case CurrentDonations
    case DonationHistory
    case Profile
    case None


    func navigation(delegate: MenuManagerDelegate) {
        createNavigationController()
        delegate.menuManage(self, changeMainViewController: MenuManager.navigationController!)
        
    }
    
    
    private struct Identifier {
        static let pendingDonationsIdentifier = "Main"
        static let currentDonationsIdentifier = "CurrentDonationLIstView"
        static let profileIdentifier = "ProfileViewController"
    }
    
    static private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    static private var navigationController: UINavigationController? = nil
    
    
    private func createNavigationController() {
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
        }
        
    }
    
}

