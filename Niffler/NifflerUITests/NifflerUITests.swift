//
//  NifflerUITests.swift
//  NifflerUITests
//
//  Created by Дарья Цыденова on 11.09.2025.
//

import XCTest

final class NifflerUITests: XCTestCase {
    
    enum Locators {
        enum Login {
            static let usernameField = "userNameTextField"
            static let passwordField = "passwordTextField"
            static let loginButton   = "loginButton"
        }
        
        enum SignUp {
            static let usernameField        = "userNameTextFieldSignUp"
            static let passwordField        = "passwordTextFieldSignUp"
            static let confirmPasswordField = "confirmPasswordTextFieldSignUp"
            static let signUpButton         = "Sign Up"
        }
        
        enum Alerts {
            static let congratulationsTitle   = "Congratulations!"
            static let congratulationsMessage = " You've registered!"
            static let loginButton            = "Log in"
        }
        
        enum SpendList {
            static let addSpendButton = "addSpendButton"
            static let spendsList = "spendsList"
            static let menuIcon = "ic_menu"
        }
        
        enum SpendForm {
            static let amountField = "amountField"
            static let descriptionField = "descriptionField"
            static let selectCategoryButton = "Select category"
            static let addCategoryAlert = "Add category"
            static let addCategoryNameField = "Name"
            static let addCategoryConfirmButton = "Add"
            static let newCategoryButton = "+ New category"
            static let addSpendButton = "Add"
        }
    }
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        launchAppWithoutLogin()
    }
    
    func testLoginSuccessful() throws {
        fillAndSubmitLoginForm(login: "stage", password: "12345")
                
        assertSpendsViewAppeared()
    }
    
    func testLoginFailure() throws {
        fillAndSubmitLoginForm(login: "stage", password: "123456")
        
        assertErrorLoginShown()
    }
    
    func testRegistration() throws {
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
        let randomUsername = generateRandomUsername()
        let randomPassword = generateRandomPassword()
  
        input(login: randomUsername)
        input(password: randomPassword)
        hideKeyboard()

        tapCreateNewAccountButton()
        waitForSignUpScreen()
        
        assertUsernameSignUpScreenPrefilled(username: randomUsername)
        assertSecurePasswordSignUpScreenPrefilled()
        assertPasswordSignUpScreenPrefilled(password: randomPassword)
    }
    
    func testAddedSpendShouldShowInSpendList() {
        fillAndSubmitLoginForm(login: "stage", password: "12345")
        waitForSpendsScreen()
        let amount = "14"
        let title = UUID().uuidString
        let category = "Спорт"
        addSpend(amount: amount, title: title, category: category)
        assertAddedSpendIsShown(title: title, category: category)
    }
    
    func testNewUserHasEmptySpendList() {
        let randomUsername = generateRandomUsername()
        let randomPassword = generateRandomPassword()
        signUpAndLogin(username: randomUsername, password: randomPassword)
        let totalLabel = app.staticTexts["0 ₽"].waitForExistence(timeout: 1)
        XCTAssert(totalLabel)
        let spends = app.otherElements.matching(identifier: "spendsList")
        XCTAssertEqual(spends.count, 0, "Ожидали пустой список трат, но нашли \(spends.count)")
    }
    
    func testNewUserAddSpendWithCategory() {
        let randomUsername = generateRandomUsername()
        let randomPassword = generateRandomPassword()
        signUpAndLogin(username: randomUsername, password: randomPassword)
        assertSpendsViewAppeared()
        let amount = "15"
        let title = UUID().uuidString
        let category = "Кофе"
        addSpend(amount: amount, title: title, category: category)
        assertSpendsViewAppeared()
        assertAddedSpendIsShown(title: title, category: category)
    }
    
    // MARK: - Domain Specific Language
    private func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запуск приложения в режиме 'без авторизации'") { _ in
            app = XCUIApplication()
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    
    // MARK: Spend list
    func clickNewSpend() {
        app.buttons[Locators.SpendList.addSpendButton].tap()
    }

    func assertAddedSpendIsShown(title: String, category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка добавленной траты в списке трат") { _ in
            let titleExists = app.otherElements[Locators.SpendList.spendsList].staticTexts[title].waitForExistence(timeout: 1)
            XCTAssertTrue(titleExists, "Описание добавленной траты '\(title)' не отображено", file: file, line: line)

            let categoryExists = app.otherElements[Locators.SpendList.spendsList].staticTexts[category].waitForExistence(timeout: 1)
            XCTAssertTrue(categoryExists, "Категория '\(category)' не отображена для добавленной траты", file: file, line: line)
        }
    }
    
    func assertSpendsViewAppeared() {
        XCTContext.runActivity(named: "Ожидание появления экрана 'Spends'") { _ in
            waitForSpendsScreen()
        }
    }
    
    // MARK: Spend form
    func inputAmount(amount: String) {
        app.textFields[Locators.SpendForm.amountField].typeText(amount)
    }
    
    func inputDescription(description: String) {
        app.textFields[Locators.SpendForm.descriptionField].tap()
        app.textFields[Locators.SpendForm.descriptionField].typeText(description)
    }
    
    func selectCategory(category: String) {
        app.buttons[Locators.SpendForm.selectCategoryButton].tap()
        // 1. Если сразу появился алерт "Add category" — вводим и подтверждаем категорию
        let addCategoryAlert = app.alerts[Locators.SpendForm.addCategoryAlert]
        if addCategoryAlert.waitForExistence(timeout: 1) {
            let nameField = addCategoryAlert.textFields[Locators.SpendForm.addCategoryNameField]
            if nameField.waitForExistence(timeout: 1) {
                nameField.tap()
                nameField.typeText(category)
            }
            addCategoryAlert.buttons[Locators.SpendForm.addCategoryConfirmButton].firstMatch.tap()
            return
        }
        // 2. Если категория уже существует — выбираем её
        let existingCategoryButton = app.buttons[category]
        if existingCategoryButton.waitForExistence(timeout: 1) {
            existingCategoryButton.tap()
            return
        }
        // 3. Если категории нет, но есть список — жмём + New category, вводим и подтверждаем
        let newCategoryButton = app.buttons[Locators.SpendForm.newCategoryButton]
        if newCategoryButton.waitForExistence(timeout: 1) {
            newCategoryButton.tap()
            let alert = app.alerts[Locators.SpendForm.addCategoryAlert]
            let nameField = alert.textFields[Locators.SpendForm.addCategoryNameField]
            if nameField.waitForExistence(timeout: 1) {
                nameField.tap()
                nameField.typeText(category)
            }
            alert.buttons[Locators.SpendForm.addCategoryAlert].firstMatch.tap()
        }
    }
    
    func clickAddSpend() {
        app.buttons[Locators.SpendForm.addSpendButton].tap()
    }
    
    // MARK: Login
    private func input(login: String) {
        XCTContext.runActivity(named: "Ввод логина \(login)") { _ in
            app.textFields[Locators.Login.usernameField].tap()
            app.textFields[Locators.Login.usernameField].typeText(login)
        }
    }
    
    private func input(password: String) {
        XCTContext.runActivity(named: "Ввод пароля \(password)") { _ in app.secureTextFields[Locators.Login.passwordField].tap()
            app.secureTextFields[Locators.Login.passwordField].typeText(password)
        }
    }
    
    private func tapLoginButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Log in") { _ in app.buttons[Locators.Login.loginButton].tap()
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
    
    private func tapTogglePassword() {
        XCTContext.runActivity(named: "Нажатие кнопки показа/скрытия пароля") { _ in
                    app.buttons[Locators.Login.passwordField].tap()
                }
    }
    
    private func waitForLoginScreen() {
        XCTContext.runActivity(named: "Ожидание экрана Log in") { _ in
            let _ = app.staticTexts["Log in"].firstMatch.waitForExistence(timeout: 10)
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
    
    func assertUsernameLoginScreenPrefilled(username: String) {
        XCTContext.runActivity(named: "Проверка предзаполнения поля username на экране Log In") { _ in
            let usernameField = app.textFields[Locators.Login.usernameField]
            XCTAssertEqual(usernameField.value as? String, username)
        }
        
    }
    
    // MARK: Signup
    private func input(usernameSignUp: String) {
        XCTContext.runActivity(named: "Ввод username \(usernameSignUp)") { _ in
            app.textFields[Locators.SignUp.usernameField].tap()
            app.textFields[Locators.SignUp.usernameField].typeText(usernameSignUp)
        }
    }
    
    private func input(passwordSignUp: String) {
        XCTContext.runActivity(named: "Ввод пароля \(passwordSignUp)") { _ in
            app.secureTextFields[Locators.SignUp.passwordField].tap()
            app.secureTextFields[Locators.SignUp.passwordField].typeText(passwordSignUp)
        
        }
    }
    
    private func input(confirmPasswordSignUp: String) {
        XCTContext.runActivity(named: "Ввод подтверждающего пароля \(confirmPasswordSignUp)") { _ in
            app.secureTextFields[Locators.SignUp.confirmPasswordField].tap()
            app.secureTextFields[Locators.SignUp.confirmPasswordField].typeText(confirmPasswordSignUp)
        }
    }
        
    private func tapSignUpButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Sign Up") { _ in
            app.buttons[Locators.SignUp.signUpButton].tap()
        }
    }
    
    private func fillAndSubmitSignUpForm(
        username: String,
        password: String,
        confirmPassword: String
    ) {
        XCTContext.runActivity(named: "Заполенение и отправка формы регистрации") { _ in
            input(usernameSignUp: username)
            input(passwordSignUp: password)
            input(confirmPasswordSignUp: confirmPassword)
            hideKeyboard()
            tapSignUpButton()
        }
    }
    
    private func waitForSignUpScreen() {
        XCTContext.runActivity(named: "Дождаться загрузки экрана Sing up") { _ in
            let _ = app.staticTexts[Locators.SignUp.signUpButton].waitForExistence(timeout: 10)
        }
    }
    
    private func waitForSpendsScreen(file: StaticString = #filePath, line: UInt = #line) {
        let isFound = app.images[Locators.SpendList.menuIcon].firstMatch.waitForExistence(timeout: 5)
        XCTAssert(isFound, "Не дождались экрана 'Spends'", file: file, line: line)
    }
    
    private func getAlert() -> XCUIElement {
        XCTContext.runActivity(named: "Получение алерта 'Congratulations!'") { _ in
            let _ = app.alerts.firstMatch.waitForExistence(timeout: 10)
            return app.alerts[Locators.Alerts.congratulationsTitle]
        }
    }
    
    private func hideKeyboard() {
        XCTContext.runActivity(named: "Скрытие клавиатуры") { _ in
            app.keyboards.buttons["Return"].tap()
        }
    }
    
    private func generateRandomUsername() -> String {
        XCTContext.runActivity(named: "Генерация имени пользователя") { _ in
            return "user_" + String(UUID().uuidString.prefix(8))
        }
    }

    private func generateRandomPassword() -> String {
        XCTContext.runActivity(named: "Генерация пароля") { _ in
            return String(Int(Date().timeIntervalSince1970))
        }
    }
    
    private func tapAlertLogInButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Log in в алерте 'Congratulations!'") { _ in
            let alert = getAlert()
            alert.buttons[Locators.Alerts.loginButton].tap()
        }
    }

    func assertSuccessAlertShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка корректности алерта 'Congratulations!'") { _ in
            let alert = getAlert()
            let alertTitleText = alert.staticTexts[Locators.Alerts.congratulationsTitle]
            XCTAssertTrue(
                alertTitleText.exists,
                "Заголовок алерта 'Congratulations!' не совпадает",
                file: file,
                line: line
            )
            let alertMessageText = alert.staticTexts[Locators.Alerts.congratulationsMessage]
            XCTAssertTrue(
                alertMessageText.exists,
                "Сообщение в алерте 'Congratulations!' не совпадает",
                file: file,
                line: line
            )
            let loginAlertButton = alert.buttons[Locators.Alerts.loginButton]
            XCTAssertTrue(
                loginAlertButton.exists,
                "Не найден кнопка Login в алерте 'Congratulations!'",
                file: file,
                line: line
            )
        }
    }
    
    func assertSecurePasswordLoginScreenPrefilled() {
        XCTContext.runActivity(named: "Проверка предзаполнения поля password на экране Log In") { _ in
            let passwordSecureField = app.secureTextFields[Locators.Login.passwordField]
            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)
        }
    }
    
    func assertPasswordLoginScreenPrefilled(password: String) {
        XCTContext.runActivity(named: "Проверка значения в предзаполненном поле password на экране Log In") { _ in
            tapTogglePassword()
            let passwordField = app.textFields[Locators.Login.passwordField]
            XCTAssertEqual(passwordField.value as? String, password)
        }
    }
    
    func assertUsernameSignUpScreenPrefilled(username: String) {
        XCTContext.runActivity(named: "Проверка предзаполнения поля username на экране Sign Up") { _ in
            let usernameField = app.textFields[Locators.SignUp.usernameField]
            XCTAssertEqual(usernameField.value as? String, username)
        }

    }
    func assertSecurePasswordSignUpScreenPrefilled() {
        XCTContext.runActivity(named: "Проверка предзаполнения поля password на экране Sign Up") { _ in
            let passwordSecureField = app.secureTextFields[Locators.SignUp.passwordField]
            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)
        }

    }
    
    func assertPasswordSignUpScreenPrefilled(password: String) {
        XCTContext.runActivity(named: "Проверка значения в предзаполненном поле password на экране Sign Up") { _ in
            app.buttons[Locators.SignUp.passwordField].tap()
            let passwordField = app.textFields[Locators.SignUp.passwordField]
            XCTAssertEqual(passwordField.value as? String, password)
        }
    }
    
    // MARK: - Helpers
    private func signUpAndLogin(username: String, password: String) {
        tapCreateNewAccountButton()
        fillAndSubmitSignUpForm(
            username: username,
            password: password,
            confirmPassword: password
        )
        tapAlertLogInButton()
        waitForLoginScreen()
        tapLoginButton()
        assertSpendsViewAppeared()
    }

    private func addSpend(amount: String, title: String, category: String) {
        clickNewSpend()
        inputAmount(amount: amount)
        inputDescription(description: title)
        selectCategory(category: category)
        clickAddSpend()
    }
}
