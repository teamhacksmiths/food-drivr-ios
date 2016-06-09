//
//  DonorAddAddressPresenter.swift
//  hackathon-for-hunger
//
//  Created by Mikael Mukhsikaroyan on 6/7/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation

protocol DonorAddAddressView: NSObjectProtocol {
    func didSaveNewAddress(address: String, city: String, state:String, zip: String)
}

class DonorAddAddressPresenter {
    private var donorAddAddressView: DonorAddAddressView?
    
    func attachView(view: DonorAddAddressView) {
        donorAddAddressView = view 
    }
    
    func detachView() {
        donorAddAddressView = nil
    }
    
    func addNewAddress() {
        
    }
    
}
