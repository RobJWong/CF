//
//  UnitTestsDemoTests.swift
//  UnitTestsDemoTests
//
//  Created by Robert Wong on 11/4/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import XCTest
@testable import UnitTestsDemo

class UnitTestsDemoTests: XCTestCase {
    
    var linksViewController: LinksViewController!
    
    func testURLPrefixValidity() {
        let urlString = "google.com"
        let hasValidURLPrefix = linksViewController.hasValidURLPrefix(urlString)
        XCTAssertFalse(hasValidURLPrefix, "URL should not have a valid prefix")
    }
    
    func testURLPrefixValidityForValidURL() {
        let urlString = "https://apple.com"
        let hasValidURLPrefix = linksViewController.hasValidURLPrefix(urlString)
        XCTAssertTrue(hasValidURLPrefix, "URL should have a valid prefix")
    }
    
    func testAddURLPrefix() {
        let urlString = "google.com"
        let urlStringWithPrefix = linksViewController.addURLPrefix(urlString)
        XCTAssertEqual(urlStringWithPrefix, "http://google.com", "URL should contain an http:// prefix")
    }
    
    func testPrepareURL() {
        let urlString = "http://google.com"
        let url = linksViewController.prepareURL(urlString)
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.host, "google.com", "URL host does not match URL string")
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        linksViewController = LinksViewController()
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
