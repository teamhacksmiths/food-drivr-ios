
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
    case GetDonations(completed: Bool , dateRange: String?)
    case GetDonation(id: String)
    case UpdateDonation(donation: Donation)
    case DeleteDonation(id: String)
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
        }
    }
    
    override var path: String {
        switch endpoint {
        case .GetDonations: return "donations"
        case .GetDonation(let id): return "/donations/\(id)"
        case .UpdateDonation(let donation): return "/donations/\(donation.id)"
        case .DeleteDonation(let id): return "/donations/\(id)"
        }
    }
    
    override var parameters: APIParams {
        switch endpoint {
        case .GetDonations(let completed, let dateRange):
            var response = [String: AnyObject]()
            response["completed"] = completed
            if let dateRange = dateRange {
                response["date_range"] = dateRange
            }
            return response
            
        case .UpdateDonation(let donation):
            return ["donation" : donation]
            
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