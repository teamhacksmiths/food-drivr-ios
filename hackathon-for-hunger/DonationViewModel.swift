//
//  DonationViewModel.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 22/04/2016.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import RealmSwift

protocol DonationDelegate: class {
    func donationViewModel(sender: DonationViewModel, didSucceed donations: Results<Donation>)
    func donationViewModel(sender: DonationViewModel, didFail error: NSError)
}

class DonationViewModel {
    
    weak var delegate: DonationDelegate?
    var donations: Results<Donation>?
    var filteredDonation: Results<Donation>?
    var realm = try! Realm()
    
    func count() ->Int {
        return donations?.count ?? 0
    }
    
    func donationAtIndex(index: Int) -> Donation {
        return donations![index]
    }
    
    func fetch(status: DonationStatus? = .Any) {
        guard let status = status where status != .Any else {
            donations = realm.objects(Donation)
            delegate?.donationViewModel(self, didSucceed: donations!)
            return
        }
        donations = realm.objects(Donation).filter("rawStatus = %@", status.rawValue)
        delegate?.donationViewModel(self, didSucceed: donations!)
        
    }
    
    func fetchRemotely(status: DonationStatus? = nil) {
        DrivrAPI.sharedInstance.getDriverDonations().then() {
            donations ->Void in
            self.donations = donations
            self.fetch(status)
            }.error {
                error in
                self.delegate?.donationViewModel(self, didFail: error as NSError)
        }
    }
    
    func updateDonationStatus(donation: Donation, status: DonationStatus) {
        DrivrAPI.sharedInstance.updateDonationStatus(donation, status:status,  success: {
            _ in
            print(donation)
            }, failure: {
                (error) in
                print(error)
        })
    }
}
