//
//  NifflerUITests.swift
//  NifflerUITests
//
//  Created by Дарья Цыденова on 11.09.2025.
//

import XCTest

final class NifflerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        launchAppWithoutLogin()
    }
    
    func testLoginSuccessful() throws {
        launchAppWithoutLogin()
        
        fillAndSubmitLoginForm(login: "stage", password: "12345")
                
        assertSpendsViewAppeared()
    }
    
    func testLoginFailure() throws {
        launchAppWithoutLogin()
        
        fillAndSubmitLoginForm(login: "stage", password: "123456")
        
        assertErrorLoginShown()
    }
    
    func testRegistration() throws {
        launchAppWithoutLogin()
        
        tapCreateNewAccountButton()
        
        let randomUsername = generateRandomUsername()
        let randomPassword = generateRandomPassword()
        
        fillAndSubmitSignUpForm(
            username: randomUsername,
            password: randomPassword,
            confirmPassword: randomPassword
        )
        
        assertSuccessAlertShown()
    }
    
    func testLoginPrefilledData() throws {
        launchAppWithoutLogin()

        tapCreateNewAccountButton()

        let randomUsername = generateRandomUsername()
        let randomPassword = generateRandomPassword()
        
        fillAndSubmitSignUpForm(
            username: randomUsername,
            password: randomPassword,
            confirmPassword: randomPassword
        )
        
        tapAlertLogInButton()
        waitForLoginScreen()
        
        assertUsernameLoginScreenPrefilled(username: randomUsername)
        assertSecurePasswordLoginScreenPrefilled()
        assertPasswordLoginScreenPrefilled(password: randomPassword)
    }

    func testSignUpPrefilledData() throws {
        launchAppWithoutLogin()

        let randomUsername = generateRandomUsername()
        let randomPassword = generateRandomPassword()
  
        input(login: randomUsername)
        input(password: randomPassword)
        hideKeyboard()

        tapCreateNewAccountButton()
        waitForSignUpScreen()
        let signUpForm = getSignUpForm()
        
        assertUsernameSignUpScreenPrefilled(username: randomUsername, signUpForm: signUpForm)
        assertSecurePasswordSignUpScreenPrefilled(signUpForm: signUpForm)
        assertPasswordSignUpScreenPrefilled(password: randomPassword, signUpForm: signUpForm)
    }
    
    // MARK: - Domain Specific Language
    private func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запуск приложения в режиме 'без авторизации'") { _ in
            app = XCUIApplication()
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    
    private func input(login: String) {
        XCTContext.runActivity(named: "Ввод логина \(login)") { _ in
            app.textFields["userNameTextField"].tap()
            app.textFields["userNameTextField"].typeText(login)
        }
    }
    
    private func input(password: String) {
        XCTContext.runActivity(named: "Ввод пароля \(password)") { _ in app.secureTextFields["passwordTextField"].tap()
            app.secureTextFields["passwordTextField"].typeText(password)
        }
    }
    
    private func input(username: String, signUpForm: XCUIElement) {
        XCTContext.runActivity(named: "Ввод username \(username)") { _ in
            signUpForm.textFields["userNameTextField"].tap()
            signUpForm.textFields["userNameTextField"].typeText(username)
        }
    }
    
    private func input(password: String, signUpForm: XCUIElement) {
        XCTContext.runActivity(named: "Ввод пароля \(password)") { _ in
            signUpForm.buttons["passwordTextField"].tap()
            signUpForm.textFields["passwordTextField"].tap()
            signUpForm.textFields["passwordTextField"].typeText(String(password))
        }
    }
    
    private func input(confirmPassword: String, signUpForm: XCUIElement) {
        XCTContext.runActivity(named: "Ввод подтверждающего пароля \(confirmPassword)") { _ in
            signUpForm.buttons["confirmPasswordTextField"].tap()
            signUpForm.textFields["confirmPasswordTextField"].tap()
            signUpForm.textFields["confirmPasswordTextField"].typeText(String(confirmPassword))
        }
    }
    
    private func tapLoginButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Log in") { _ in app.buttons["loginButton"].tap()
        }
    }
    
    private func fillAndSubmitLoginForm(login: String, password: String) {
        XCTContext.runActivity(named: "Заполнение и отправка формы авторизации") { _ in
            input(login: login)
            input(password: password)
            tapLoginButton()
        }
    }
    
    private func tapCreateNewAccountButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Create new account") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    private func tapSignUpButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Sign Up") { _ in
            app.buttons["Sign Up"].tap()
        }
    }
    
    private func tapTogglePassword() {
        XCTContext.runActivity(named: "Нажатие кнопки показа/скрытия пароля") { _ in
            app.buttons["passwordTextField"].tap()
        }
    }
    
    private func fillAndSubmitSignUpForm(
        username: String,
        password: String,
        confirmPassword: String
    ) {
        XCTContext.runActivity(named: "Заполенение и отправка формы регистрации") { _ in
            let signUpForm = getSignUpForm()
            input(username: username, signUpForm: signUpForm)
            input(password: password, signUpForm: signUpForm)
            input(confirmPassword: confirmPassword, signUpForm: signUpForm)
            hideKeyboard()
            tapSignUpButton()
        }
    }
    
    private func waitForSignUpScreen() {
        XCTContext.runActivity(named: "Дождаться загрузки экрана Sing up") { _ in
            let _ = app.staticTexts["Sign Up"].waitForExistence(timeout: 10)
        }
    }
    
    private func waitForLoginScreen() {
        XCTContext.runActivity(named: "Ожидание экрана Log in") { _ in
            let _ = app.staticTexts["Log in"].firstMatch.waitForExistence(timeout: 10)
        }
    }
    
    private func getSignUpForm() -> XCUIElement {
        XCTContext.runActivity(named: "Получение формы регистрации") { _ in
            return app.otherElements.containing(.staticText, identifier: "Sign Up").element
        }
    }
    
    private func getAlert() -> XCUIElement {
        XCTContext.runActivity(named: "Получение алерта 'Congratulations!'") { _ in
            let _ = app.alerts.firstMatch.waitForExistence(timeout: 10)
            return app.alerts["Congratulations!"]
        }
    }
    
    private func hideKeyboard() {
        XCTContext.runActivity(named: "Скрытие клавиатуры") { _ in
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func generateRandomUsername() -> String {
        XCTContext.runActivity(named: "Генерация имени пользователя") { _ in
            return "user_" + String(Int(Date().timeIntervalSince1970))
        }
    }

    private func generateRandomPassword() -> String {
        XCTContext.runActivity(named: "Генарация пароля") { _ in
            return String(Int(Date().timeIntervalSince1970))
        }
    }
    
    private func tapAlertLogInButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Log in в алерте 'Congratulations!'") { _ in
            let alert = getAlert()
            alert.buttons["Log in"].tap()
        }
    }
    
    func assertSpendsViewAppeared() {
        XCTContext.runActivity(named: "Ожидание появления экрана с тратами") { _ in
            let _ = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        }
    }
    
    func assertErrorLoginShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидание появления сообщения об ошибке авторизации") { _ in
            let isFound = app.staticTexts["Нет такого пользователя. Попробуйте другие данные"].waitForExistence(timeout: 10)
            XCTAssertTrue(
                isFound,
                "Не нашли сообщение об ошибке о неправильном логине",
                file: file,
                line: line
            )
        }
    }
    
    func assertSuccessAlertShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка корректности алерта 'Congratulations!'") { _ in
            let alert = getAlert()
            let alertTitleText = alert.staticTexts["Congratulations!"]
            XCTAssertTrue(
                alertTitleText.exists,
                "Заголовок алерта 'Congratulations!' не совпадает",
                file: file,
                line: line
            )
            let alertMessageText = alert.staticTexts[" You've registered!"]
            XCTAssertTrue(
                alertMessageText.exists,
                "Сообщение в алерте 'Congratulations!' не совпадает",
                file: file,
                line: line
            )
            let loginAlertButton = alert.buttons["Log in"]
            XCTAssertTrue(
                loginAlertButton.exists,
                "Не найден кнопка Login в алерте 'Congratulations!'",
                file: file,
                line: line
            )
        }
    }
    
    func assertUsernameLoginScreenPrefilled(username: String) {
        XCTContext.runActivity(named: "Проверка предзаполнения поля username на экране Log In") { _ in
            let usernameField = app.textFields["userNameTextField"]
            XCTAssertEqual(usernameField.value as? String, username)
        }
        
    }
    
    func assertSecurePasswordLoginScreenPrefilled() {
        XCTContext.runActivity(named: "Проверка предзаполнения поля password на экране Log In") { _ in
            let passwordSecureField = app.secureTextFields["passwordTextField"]
            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)
        }
    }
    
    func assertPasswordLoginScreenPrefilled(password: String) {
        XCTContext.runActivity(named: "Проверка значения в предзаполненном поле password на экране Log In") { _ in
            tapTogglePassword()
            let passwordField = app.textFields["passwordTextField"]
            XCTAssertEqual(passwordField.value as? String, password)
        }
    }
    
    func assertUsernameSignUpScreenPrefilled(username: String, signUpForm: XCUIElement) {
        XCTContext.runActivity(named: "Проверка предзаполнения поля username на экране Sign Up") { _ in
            let usernameField = signUpForm.textFields["userNameTextField"]
            XCTAssertEqual(usernameField.value as? String, username)
        }

    }
    func assertSecurePasswordSignUpScreenPrefilled(signUpForm: XCUIElement) {
        XCTContext.runActivity(named: "Проверка предзаполнения поля password на экране Sign Up") { _ in
            let passwordSecureField = signUpForm.secureTextFields["passwordTextField"]
            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)
        }

    }
    
    func assertPasswordSignUpScreenPrefilled(password: String, signUpForm: XCUIElement) {
        XCTContext.runActivity(named: "Проверка значения в предзаполненном поле password на экране Sign Up") { _ in
            signUpForm.buttons["passwordTextField"].tap()
            let passwordField = signUpForm.textFields["passwordTextField"]
            XCTAssertEqual(passwordField.value as? String, password)
        }
    }
}
