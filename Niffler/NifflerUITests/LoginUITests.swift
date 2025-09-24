//
//  LoginUITests.swift
//  Niffler
//
//  Created by Дарья Цыденова on 19.09.2025.
//
import XCTest

final class LoginUITests: TestCase {
        
    func testLoginSuccessful() throws {
        let loginPage = LoginPage(app: app)
        
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "12345")
        
        let spendsPage = SpendsPage(app: app)
        
        spendsPage.assertSpendsViewAppeared()
    }
    
    func testLoginFailure() throws {
        let loginPage = LoginPage(app: app)
        
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "123456")
        
        loginPage.assertErrorLoginShown()
    }
    
    func testLoginPrefilledData() throws {
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
        
        signupPage.tapAlertLogInButton()
        loginPage.waitForLoginScreen()
        
        loginPage.assertUsernameLoginScreenPrefilled(username: randomUsername)
        loginPage.assertSecurePasswordLoginScreenPrefilled()
        loginPage.assertPasswordLoginScreenPrefilled(password: randomPassword)
    }
}
