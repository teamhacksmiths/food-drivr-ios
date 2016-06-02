//
//  DashboardPresenter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/6/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

protocol DonationDashboardView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func donations(sender: DonationDashboardPresenter, didSucceed donations: Results<Donation>)
    func donations(sender: DonationDashboardPresenter, didFail error: NSError)
    func donationStatusUpdate(sender: DonationDashboardPresenter, didSucceed donation: Donation)
    func donationStatusUpdate(sender: DonationDashboardPresenter, didFail error: NSError)
}

class DonationDashboardPresenter {
    
    private let donationService: DonationService
    private var dashboardView : DonationDashboardView?
    var realm = try! Realm()
    
    init(donationService: DonationService){
        self.donationService = donationService
    }
    
    func attachView(view: DonationDashboardView){
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
        donationService.getDonorDonations().then() {
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