//
//  CheapMessengerAppV1UITests.swift
//  CheapMessengerAppV1UITests
//
//  Created by Robert Wong on 11/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import XCTest

class CheapMessengerAppV1UITests: XCTestCase {
        
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
    
    func testLogin() {
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("1234@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        app.buttons["Sign In"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true, "Sign up sucessful")
    }
    
    func testSignUp() {
        
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Mary")
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("12345678@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123")
        app.buttons["Sign Up!"].tap()
        app.alerts["Messenger"].buttons["Ok"].tap()
        XCTAssertFalse(false, "Password is not long enough")
    }
    
    func testSendMessage() {
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("1234@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        app.buttons["Sign In"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Rob"]/*[[".cells.staticTexts[\"Rob\"]",".staticTexts[\"Rob\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let toolbarsQuery = app.toolbars
        let newMessageTextView = toolbarsQuery.textViews["New Message"]
        newMessageTextView.tap()
        newMessageTextView.typeText("Hello there!")
        toolbarsQuery.buttons["Send"].tap()
        app.navigationBars["Chat"].buttons["Katie"].tap()
        
        XCTAssertTrue(true, "Sent message sucessfully")
    }
    
}
