//
//  SignupUITests.swift
//  Niffler
//
//  Created by Дарья Цыденова on 19.09.2025.
//
import XCTest

final class SignupUITests: TestCase {
        
    func testRegistration() throws {
        let loginPage = LoginPage(app: app)
        
        loginPage.tapCreateNewAccountButton()
        
        let signupPage = SignupPage(app: app)
        
        let randomUsername = signupPage.generateRandomUsername()
        let randomPassword = signupPage.generateRandomPassword()
        
        signupPage.fillAndSubmitSignupForm(
            username: randomUsername,
            password: randomPassword,
            confirmPassword: randomPassword
        )
        
        signupPage.assertSuccessAlertShown()
    }
    
    func testSignUpPrefilledData() throws {
        let loginPage = LoginPage(app: app)
        let signupPage = SignupPage(app: app)
        
        let randomUsername = signupPage.generateRandomUsername()
        let randomPassword = signupPage.generateRandomPassword()
        
        loginPage.input(login: randomUsername)
        loginPage.input(password: randomPassword)
        loginPage.hideKeyboard()
        loginPage.tapCreateNewAccountButton()
        
        signupPage.waitForSignupScreen()
        
        signupPage.assertUsernameSignupScreenPrefilled(username: randomUsername)
        signupPage.assertSecurePasswordSignupScreenPrefilled()
        signupPage.assertPasswordSignupScreenPrefilled(password: randomPassword)
    }
}
