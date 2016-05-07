//
//  MapViewPresenter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 5/7/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

protocol MapView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func donationStatusUpdate(sender: MapViewPresenter, didSucceed donation: Donation)
    func donationStatusUpdate(sender: MapViewPresenter, didFail error: NSError)
}

class MapViewPresenter {
    
    private let donationService: DonationService
    private let donation: Donation?
    private var mapView : MapView?
    var realm = try! Realm()
    
    init(donationService: DonationService, donation: Donation){
        self.donationService = donationService
        self.donation = donation
    }
    
    func attachView(view: MapView){
        mapView = view
    }
    
    func detachView() {
        mapView = nil
    }
    
    func getDonation() -> Donation {
        return self.donation!
    }
    
    func updateDonationStatus(donation: Donation, status: DonationStatus) {
        //temp faux call as no api
        delay(2) {
            self.mapView?.donationStatusUpdate(self, didSucceed: donation)
        }
        
//        donationService.updateDonationStatus(donation, status:status).then {
//            donation in
//            print(donation)
//        }
    }
}