//
//  MapOverviewPresenter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/7/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

protocol MapOverviewView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func donations(sender: MapOverviewPresenter, didSucceed donations: Results<Donation>)
    func donations(sender: MapOverviewPresenter, didFail error: NSError)
}

class MapOverviewPresenter {
    
    private let donationService: DonationService
    private var mapOverviewView : MapOverviewView?
    var realm = try! Realm()
    
    init(donationService: DonationService){
        self.donationService = donationService
    }
    
    func attachView(view: MapOverviewView){
        mapOverviewView = view
    }
    
    func detachView() {
        mapOverviewView = nil
    }
    
    func fetch(status: DonationStatus? = .Any) {
        guard let status = status where status != .Any else {
            let donations = realm.objects(Donation)
            self.mapOverviewView?.donations(self, didSucceed: donations)
            return
        }
        let donations = realm.objects(Donation).filter("rawStatus = %@", status.rawValue)
        self.mapOverviewView?.donations(self, didSucceed: donations)
        
    }
    
    func fetchRemotely(status: DonationStatus? = nil) {
        donationService.getDriverDonations().then() {
            donations -> Void in
            self.fetch(status)
            }.error {
                error in
                self.mapOverviewView?.donations(self, didFail: error as NSError)
        }
    }
}
