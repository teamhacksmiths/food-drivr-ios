//
//  DonationRouterTest.swift
//  hackathon-for-hunger
//
//  Created by Ian Gristock on 3/31/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import XCTest

@testable import hackathon_for_hunger
class DonationRouterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDonationRequestHasRouteCorrect() {
        // Do any additional setup after loading the view, typically from a nib.
        let router = DonationRouter(endpoint: DonationEndpoint.GetDonations(completed: false, dateRange: "2016-03-31:2016-04-01"))
        let expected = "INSERT_BASE_URL_HERE/donations?completed=0&date_range=2016-03-31%3A2016-04-01"
        let actual = router.URLRequest.URL!.absoluteString
        XCTAssertEqual(actual, expected)
    }
    
    func testDonationRequestHasVerbCorrect() {
        // Do any additional setup after loading the view, typically from a nib.
        let router = DonationRouter(endpoint: DonationEndpoint.GetDonations(completed: false, dateRange: "2016-03-31:2016-04-01"))
        let expected = "GET"
        let actual = router.URLRequest.HTTPMethod
        XCTAssertEqual(actual, expected)
    }
    
}
