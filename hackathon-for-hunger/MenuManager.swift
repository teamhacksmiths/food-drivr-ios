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
    
    case Dashboard = 0
    case DonationOverView
    case Profile
    case None


    func navigation(delegate: MenuManagerDelegate) {
        createNavigationController()
        delegate.menuManage(self, changeMainViewController: MenuManager.navigationController!)
        
    }
    
    
    private struct Identifier {
        static let dashboardIdentifier = "Main"
        static let donationOverViewIdentifier = "DonationOverviewMap"
        static let profileIdentifier = "ProfileViewController"
    }
    
    static private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    static private var navigationController: UINavigationController? = nil
    
    
    private func createNavigationController() {
        switch self {
            case .Dashboard:
                let dashboardVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.dashboardIdentifier)
                                            as! PendingDonationsDashboard
                MenuManager.navigationController = UINavigationController(rootViewController: dashboardVC)
            case .DonationOverView:
                let donationOverVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.donationOverViewIdentifier)
                    as! DonationMapOverviewVC
                MenuManager.navigationController = UINavigationController(rootViewController: donationOverVC)
        
                // prepare for Core Location (allowing user location on maps)
                let locationManager = LocationManager.sharedInstance.locationManager
                locationManager.delegate = LocationManager.sharedInstance
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            
            case .Profile:
                let profileVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.profileIdentifier)
                    as! ProfileViewController
                MenuManager.navigationController = UINavigationController(rootViewController: profileVC)
            case None:
                break
        }
        
    }
    
}

