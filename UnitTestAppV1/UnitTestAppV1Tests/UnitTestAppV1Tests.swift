//
//  UnitTestAppV1Tests.swift
//  UnitTestAppV1Tests
//
//  Created by Robert Wong on 11/4/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import XCTest
@testable import UnitTestAppV1

class UnitTestAppV1Tests: XCTestCase {
    
    var viewControllerTest: ViewController!
    
    func testValidatePasswordNumberReq() {
        let passwordString = "123C"
        let validateNumbers = viewControllerTest.validatePasswordNumberReq(password: passwordString)
        XCTAssertTrue(validateNumbers, "Valid password string")
    }
    
    func testValidatePasswordCapitalReq() {
        let passwordString = "14C"
        let validateCapitals = viewControllerTest.validatePasswordCapitalReq(password: passwordString)
        XCTAssertTrue(validateCapitals, "Invalid password string")
    }
    
    func testValidatePasswordCount() {
        let passwordString = "12345ccc"
        let validateCount = viewControllerTest.validatePasswordCharCountReq(password: passwordString)
        XCTAssertTrue(validateCount, "Correct number count")
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewControllerTest = ViewController()
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
    
}
