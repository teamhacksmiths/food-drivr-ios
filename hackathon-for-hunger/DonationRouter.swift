
//
//  DonationRouter.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/30/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import Foundation
import Alamofire

enum DonationEndpoint {
    case GetDonations(completed: Bool , status: Int)
    case GetDonation(id: String)
    case UpdateDonation(donation: Donation)
    case DeleteDonation(id: String)
    case UpdateDonationStatus(donation: Donation, status: [String: AnyObject])
}

class DonationRouter : BaseRouter {
    
    var endpoint: DonationEndpoint
    init(endpoint: DonationEndpoint) {
        self.endpoint = endpoint
    }
    
    override var method: Alamofire.Method {
        switch endpoint {
        case .GetDonations: return .GET
        case .GetDonation: return .GET
        case .UpdateDonation: return .PUT
        case .DeleteDonation: return .DELETE
        case .UpdateDonationStatus: return .POST
        }
    }
    
    override var path: String {
        switch endpoint {
        case .GetDonations: return "driver/donations/all"
        case .GetDonation(let id): return "driver/donations/\(id)"
        case .UpdateDonation(let donation): return "driver/donations/\(donation.id)"
        case .DeleteDonation(let id): return "driver/donations/\(id)"
        case .UpdateDonationStatus(let donation, _): return "driver/donations/\(donation.id)/status"
        }
    }
    
    override var parameters: APIParams {
        switch endpoint {
        case .GetDonations(let completed, let status):
            var response = [String: AnyObject]()
            response["completed"] = completed
            response["status"] = status
            return response
            
        case .UpdateDonation(let donation):
            return ["donation" : donation]
        case .UpdateDonationStatus( _, let status):
            return ["status" : status]
        default: return nil
        }
    }
    
    override var encoding: Alamofire.ParameterEncoding? {
        switch endpoint {
        case .GetDonations: return .URL
        case .GetDonation: return .URL
        default: return .JSON
        }
    }
    
}