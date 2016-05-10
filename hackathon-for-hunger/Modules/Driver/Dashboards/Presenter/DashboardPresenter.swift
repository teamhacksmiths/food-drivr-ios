//
//  DashboardPresenter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/6/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

protocol DashboardView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func donations(sender: DashboardPresenter, didSucceed donations: Results<Donation>)
    func donations(sender: DashboardPresenter, didFail error: NSError)
    func donationStatusUpdate(sender: DashboardPresenter, didSucceed donation: Donation)
    func donationStatusUpdate(sender: DashboardPresenter, didFail error: NSError)
}

class DashboardPresenter {
    
    private let donationService: DonationService
    private var dashboardView : DashboardView?
    var realm = try! Realm()
    
    init(donationService: DonationService){
        self.donationService = donationService
    }
    
    func attachView(view: DashboardView){
        dashboardView = view
    }
    
    func detachView() {
        dashboardView = nil
    }
    
    func fetch(status: [Int]?) {
        guard let status = status where status.count > 0 else {
            let donations = realm.objects(Donation)
            self.dashboardView?.donations(self, didSucceed: donations)
            return
        }
        let donations = realm.objects(Donation).filter("rawStatus IN %@", status)
        self.dashboardView?.donations(self, didSucceed: donations)
        
    }
    
    func fetchRemotely(status: [Int]?) {
        donationService.getDriverDonations().then() {
            donations -> Void in
            self.fetch(status)
            }.error {
                error in
                self.dashboardView?.donations(self, didFail: error as NSError)
        }
    }
    
    func updateDonationStatus(donation: Donation, status: DonationStatus) {
        donationService.updateDonationStatus(donation, status:status).then {
            donation -> Void in
            self.dashboardView?.donationStatusUpdate(self, didSucceed: donation)
            }.error {
                error in
                self.dashboardView?.donationStatusUpdate(self, didFail: error as NSError)
        }
    }
}