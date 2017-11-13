//
//  CustomControlAppV2UITests.swift
//  CustomControlAppV2UITests
//
//  Created by Robert Wong on 11/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import XCTest

class CustomControlAppV2UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let element2 = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element
        let element = element2.children(matching: .other).element.children(matching: .other).element
        element.tap()
        element.swipeLeft()
        element.swipeRight()
        element.swipeRight()
        element2.swipeRight()
        element.swipeRight()
        element.swipeRight()
        element.swipeRight()
        element.swipeRight()
        element2.swipeRight()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeDown()
        element.swipeUp()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element/*@START_MENU_TOKEN@*/.press(forDuration: 1.8);/*[[".tap()",".press(forDuration: 1.8);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        element.tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
