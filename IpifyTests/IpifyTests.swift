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
		
		Ipify.serviceURL = "https://api.ipify.org?format=json"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformance() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
			
			Ipify.getPublicIPAddress { result in
				switch result {
				case .success(let ip):
					print(ip)
				case .failure(let error):
					print(error)
				}
			}
        }
    }
	
	func testGetPublicIPAddressGoodCase() {
		let expectation = self.expectation(description: "Query public IP address from api.ipify.org should succeed")

		Ipify.getPublicIPAddress { result in
			switch result {
			case .success(let ip):
				XCTAssertTrue(self.validateIpAddress(ipToValidate: ip), "\(ip) should be a valid IP address")
				
			case .failure(let error):
				XCTFail("Fail to query IP address from the server - \(error.localizedDescription)")
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 20.0, handler: nil)
	}

	func testBadHostnameSimulateHostdown() {
		let expectation = self.expectation(description: "Query public IP address from api.ipify.org should fail")
		
		Ipify.serviceURL = "https://api.ipify.orP?format=json"
		
		Ipify.getPublicIPAddress { result in
			switch result {
			case .success(let ip):
				XCTAssertTrue(self.validateIpAddress(ipToValidate: ip), "\(ip) should be a valid IP address")
				
			case .failure(let error):
				print("Successfully failed to connect to non-existant server - \(error.localizedDescription)")
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 20.0, handler: nil)
	}

	func testNoDataResponse() {
		
		Ipify.handleIpifyResponse(with: nil, error: nil) { result in
			switch result {
			case .success(_):
				XCTFail("Expecting no data")
				
			case .failure(let error):
				switch error {
				case .noData:
					print("PASS")
				case .invalidJson:
					XCTFail("Expecting no data - \(error.localizedDescription)")
				case .otherError(let err):
					XCTFail("Expecting no data - \(err.localizedDescription)")
				}
			}
		}
	}

	func testParsingInvalidJSON() {
		
		Ipify.handleIpifyResponse(with: "][".data(using: .utf8), error: nil) { result in
			switch result {
			case .success(_):
				XCTFail("Expecting invalid JSON")
				
			case .failure(let error):
				switch error {
				case .noData:
					XCTFail("Expecting invalid JSON")
				case .invalidJson:
					print("PASS")
				case .otherError(let err):
					XCTFail("Expecting invalid JSON - \(err.localizedDescription)")
				}
			}
		}
	}

	func testOtherError() {
		
		let otherErr = NSError(domain: "other error domain", code: 1234, userInfo: nil)
		
		Ipify.handleIpifyResponse(with: "[]".data(using: .utf8), error: otherErr) { result in
			switch result {
			case .success(_):
				XCTFail("Expecting Other Error")
				
			case .failure(let error):
				switch error {
				case .noData:
					XCTFail("Expecting Other Error")
				case .invalidJson:
					XCTFail("Expecting Other Error")
				case .otherError(let err):
					print("PASS - \(err.localizedDescription)")
				}
			}
		}
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
