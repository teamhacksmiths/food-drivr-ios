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

//
//
//protocol MenuManagerDelegate {
//    func menuManage(menuManager: MenuManager,changeMainViewController navigationController: UINavigationController)
//
//}
//
//protocol Menu {
//    var storyboard: UIStoryboard { get set }
//    var navigationController: UINavigationController { get set }
//    func navigation(delegate: MenuManagerDelegate)
//    
//}
//
//
//
//
//
//enum MenuManager: Int {
//    
//
//    case PendingDonations = 0
//    case CurrentDonations
//    case DonationHistory
//    case Profile
//    case None
//
//    case Dashboard
//    case Donations
//    case MyProfile
//    case Addresses
//
//    func navigation(delegate: MenuManagerDelegate) {
//        createNavigationControllerForDonor()
//        delegate.menuManage(self, changeMainViewController: MenuManager.navigationController!)
//        
//    }
//    
//    
//    private struct Identifier {
//        static let pendingDonationsIdentifier = "Main"
//        static let currentDonationsIdentifier = "CurrentDonationLIstView"
//        static let profileIdentifier = "ProfileViewController"
//    }
//    
//    static private let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    static private var navigationController: UINavigationController? = nil
//    
//    
//    private func createNavigationControllerForDonor() {
//        switch self {
//            case .PendingDonations:
//                let dashboardVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.pendingDonationsIdentifier)
//                                            as! DonationsContainerViewController
//                MenuManager.navigationController = UINavigationController(rootViewController: dashboardVC)
//            
//            case .CurrentDonations:
//                let donationOverVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.currentDonationsIdentifier)
//                    as! CurrentDonationsDashboard
//                MenuManager.navigationController = UINavigationController(rootViewController: donationOverVC)
//            
//        case .DonationHistory:
//            let profileVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.currentDonationsIdentifier)
//                as! CurrentDonationsDashboard
//            MenuManager.navigationController = UINavigationController(rootViewController: profileVC)
//            
//            case .Profile:
//                let profileVC = MenuManager.storyboard.instantiateViewControllerWithIdentifier(Identifier.profileIdentifier)
//                    as! ProfileViewController
//                MenuManager.navigationController = UINavigationController(rootViewController: profileVC)
//            
//            case None:
//                break
//        default:break
//        }
//        
//    }
//    private func createNavigationControllerForDriver(){
//        switch self {
//        case .Dashboard:
//            break
//        case .Donations:
//            break
//        case .MyProfile:
//            break
//        case .Addresses:
//            break
//        case .None:
//            break
//        default:break
//        }
//    }
//    
//}
//
//
//
//
////