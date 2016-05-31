//
//  DashboardPresenter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/6/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

protocol DonationView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func donations(sender: DonationPresenter, didSucceed donation: Donation)
    func donations(sender: DonationPresenter, didFail error: NSError)
}

class DonationPresenter {
    
    private let donationService: DonationService
    private var donationView : DonationView?
    var realm = try! Realm()
    
    init(donationService: DonationService){
        self.donationService = donationService
    }
    
    func attachView(view: DonationView){
        donationView = view
    }
    
    func detachView() {
        donationView = nil
    }
    
    func createDonation(items: [String]?) {
        guard let items = items where items.count > 0 else {
            self.donationView?.donations(self, didFail: NSError(domain: "No Donation Items Found", code: 422, userInfo: nil))
            return
        }
        self.donationService.createDonation(items).then() {
            donation -> Void in
            self.donationView?.donations(self, didSucceed: donation)
            }.error {
                error in
                self.donationView?.donations(self, didFail: error as NSError)
        }
        
    }
}