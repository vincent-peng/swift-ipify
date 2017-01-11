//
//  IpifyTests.swift
//  IpifyTests
//
//  Created by Vincent Peng on 1/10/17.
//  Copyright © 2017 Vincent Peng. All rights reserved.
//

import XCTest
@testable import Ipify

class IpifyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testGetPublicIPAddress() {
		let expectation = self.expectation(description: "Query public IP address from api.ipify.org should succeed")

		Ipify.getPublicIPAddress { result in
			switch result {
			case .success(let ip):
				XCTAssertTrue(self.validateIpAddress(ipToValidate: ip), "\(ip) should be a valid IP address")
				
			case .failure(_):
				XCTFail("Fail to query IP address from the server")
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 20.0, handler: nil)
	}
	
	
	private func validateIpAddress(ipToValidate: String) -> Bool {
		var sin = sockaddr_in()
		var sin6 = sockaddr_in6()
		
		if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
			// IPv6 peer.
			return true
		}
		else if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
			// IPv4 peer.
			return true
		}
		
		return false;
	}
}
