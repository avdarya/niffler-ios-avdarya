//
//  NifflerUITests.swift
//  NifflerUITests
//
//  Created by Дарья Цыденова on 11.09.2025.
//

import XCTest

final class NifflerUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["userNameTextField"].tap()
        app.textFields["userNameTextField"].typeText("stage")
        app.secureTextFields["passwordTextField"].tap()
        app.secureTextFields["passwordTextField"].typeText("12345")
        app.buttons["loginButton"].tap()
        
        let _ = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
        XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)

    }
    
    func testRegistration() throws {
        let randomUsername = "user_" + String(Int(Date().timeIntervalSince1970))
        let randomPassword = String(Int(Date().timeIntervalSince1970))
        
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Create new account"].tap()
        
        let _ = app.staticTexts["Sign Up"].waitForExistence(timeout: 10)
        let signUpForm = app.otherElements.containing(.staticText, identifier: "Sign Up").element
        
        signUpForm.textFields["userNameTextField"].tap()
        signUpForm.textFields["userNameTextField"].typeText(randomUsername)
        
        signUpForm.buttons["passwordTextField"].tap()
        signUpForm.textFields["passwordTextField"].tap()
        signUpForm.textFields["passwordTextField"].typeText(String(randomPassword))
        
        
        signUpForm.buttons["confirmPasswordTextField"].tap()
        signUpForm.textFields["confirmPasswordTextField"].tap()
        signUpForm.textFields["confirmPasswordTextField"].typeText(String(randomPassword))
        
        app.keyboards.buttons["Return"].tap()
        
        app.buttons["Sign Up"].tap()
        
        let _ = app.alerts.firstMatch.waitForExistence(timeout: 10)

        let alert = app.alerts["Congratulations!"]
        
        let alertTitleText = alert.staticTexts["Congratulations!"]
        XCTAssertTrue(alertTitleText.exists)

        let alertmessageText = alert.staticTexts[" You've registered!"]
        XCTAssertTrue(alertmessageText.exists)

        let loginAlertButton = alert.buttons["Log in"]
        XCTAssertTrue(loginAlertButton.exists)

    }
    
    func testLoginPrefilledData() throws {
        let randomUsername = "user_" + String(Int(Date().timeIntervalSince1970))
        let randomPassword = String(Int(Date().timeIntervalSince1970))
        
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Create new account"].tap()
        
        let _ = app.staticTexts["Sign Up"].waitForExistence(timeout: 10)
        let signUpForm = app.otherElements.containing(.staticText, identifier: "Sign Up").element
        signUpForm.textFields["userNameTextField"].tap()
        signUpForm.textFields["userNameTextField"].typeText(randomUsername)
        signUpForm.buttons["passwordTextField"].tap()
        signUpForm.textFields["passwordTextField"].tap()
        signUpForm.textFields["passwordTextField"].typeText(String(randomPassword))
        signUpForm.buttons["confirmPasswordTextField"].tap()
        signUpForm.textFields["confirmPasswordTextField"].tap()
        signUpForm.textFields["confirmPasswordTextField"].typeText(String(randomPassword))
        app.keyboards.buttons["Return"].tap()
        app.buttons["Sign Up"].tap()
        
        let _ = app.alerts.firstMatch.waitForExistence(timeout: 10)

        app.alerts["Congratulations!"].buttons["Log in"].tap()
        
        let _ = app.staticTexts["Log in"].firstMatch.waitForExistence(timeout: 10)

        let usernameField = app.textFields["userNameTextField"]
        XCTAssertEqual(usernameField.value as? String, randomUsername)
        
        let passwordSecureField = app.secureTextFields["passwordTextField"]
        XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)
        
        app.buttons["passwordTextField"].tap()
        let passwordField = app.textFields["passwordTextField"]
        XCTAssertEqual(passwordField.value as? String, randomPassword)
        
    }

    func testSignUpPrefilledData() throws {
        let randomUsername = "user_" + String(Int(Date().timeIntervalSince1970))
        let randomPassword = String(Int(Date().timeIntervalSince1970))
        
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["userNameTextField"].tap()
        app.textFields["userNameTextField"].typeText(randomUsername)
        app.secureTextFields["passwordTextField"].tap()
        app.secureTextFields["passwordTextField"].typeText(randomPassword)
        
        app.keyboards.buttons["Return"].tap()
        
        app.staticTexts["Create new account"].tap()

        let _ = app.staticTexts["Sign Up"].waitForExistence(timeout: 10)
        let signUpForm = app.otherElements.containing(.staticText, identifier: "Sign Up").element
        
        let usernameField = signUpForm.textFields["userNameTextField"]
        XCTAssertEqual(usernameField.value as? String, randomUsername)

        let passwordSecureField = signUpForm.secureTextFields["passwordTextField"]
        XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)

        signUpForm.buttons["passwordTextField"].tap()
        let passwordField = signUpForm.textFields["passwordTextField"]
        XCTAssertEqual(passwordField.value as? String, randomPassword)

    }
    
}
