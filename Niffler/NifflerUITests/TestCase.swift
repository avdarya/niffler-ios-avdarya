//
//  TestCase.swift
//  Niffler
//
//  Created by Дарья Цыденова on 19.09.2025.
//
import XCTest

class Page {
    init(app: XCUIApplication) {
        self.app = app
    }
    
    let app: XCUIApplication
    
    func hideKeyboard() {
        XCTContext.runActivity(named: "Скрытие клавиатуры") { _ in
            app.keyboards.buttons["Return"].tap()
        }
    }
}

class LoginPage: Page {
    enum Locators {
        enum Login {
            static let usernameField = "userNameTextField"
            static let passwordField = "passwordTextField"
            static let loginButton   = "loginButton"
            static let createNewAccountButton = "Create new account"
            static let loginTitle = "Log in"
            static let loginErrorMessage = "Нет такого пользователя. Попробуйте другие данные"
        }
    }
    
    func input(login: String) {
        XCTContext.runActivity(named: "Ввод логина \(login)") { _ in
            app.textFields[Locators.Login.usernameField].tap()
            app.textFields[Locators.Login.usernameField].typeText(login)
        }
    }
    
    func input(password: String) {
        XCTContext.runActivity(named: "Ввод пароля \(password)") { _ in app.secureTextFields[Locators.Login.passwordField].tap()
            app.secureTextFields[Locators.Login.passwordField].typeText(password)
        }
    }
    
    func tapLoginButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Log in") { _ in app.buttons[Locators.Login.loginButton].tap()
        }
    }
    
    func fillAndSubmitLoginForm(login: String, password: String) {
        XCTContext.runActivity(named: "Заполнение и отправка формы авторизации") { _ in
            input(login: login)
            input(password: password)
            tapLoginButton()
        }
    }
    
    func tapCreateNewAccountButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Create new account") { _ in
            app.staticTexts[Locators.Login.createNewAccountButton].tap()
        }
    }
    
    private func tapTogglePassword() {
        XCTContext.runActivity(named: "Нажатие кнопки показа/скрытия пароля") { _ in
                    app.buttons[Locators.Login.passwordField].tap()
                }
    }
    
    func waitForLoginScreen() {
        XCTContext.runActivity(named: "Ожидание экрана Log in") { _ in
            let _ = app.staticTexts[Locators.Login.loginTitle].firstMatch.waitForExistence(timeout: 10)
        }
    }
    
    func assertErrorLoginShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидание появления сообщения об ошибке авторизации") { _ in
            let isFound = app.staticTexts[Locators.Login.loginErrorMessage].waitForExistence(timeout: 10)
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
}

class SignupPage: Page {
    enum Locators {
        enum Signup {
            static let usernameField        = "userNameTextFieldSignUp"
            static let passwordField        = "passwordTextFieldSignUp"
            static let confirmPasswordField = "confirmPasswordTextFieldSignUp"
            static let signupButton         = "Sign Up"
        }
        enum Alerts {
            static let congratulationsTitle   = "Congratulations!"
            static let congratulationsMessage = " You've registered!"
            static let loginButton            = "Log in"
        }
    }
    private func input(usernameSignup: String) {
        XCTContext.runActivity(named: "Ввод username \(usernameSignup)") { _ in
            app.textFields[Locators.Signup.usernameField].tap()
            app.textFields[Locators.Signup.usernameField].typeText(usernameSignup)
        }
    }
    
    private func input(passwordSignup: String) {
        XCTContext.runActivity(named: "Ввод пароля \(passwordSignup)") { _ in
            app.secureTextFields[Locators.Signup.passwordField].tap()
            app.secureTextFields[Locators.Signup.passwordField].typeText(passwordSignup)
        
        }
    }
    
    private func input(confirmPasswordSignup: String) {
        XCTContext.runActivity(named: "Ввод подтверждающего пароля \(confirmPasswordSignup)") { _ in
            app.secureTextFields[Locators.Signup.confirmPasswordField].tap()
            app.secureTextFields[Locators.Signup.confirmPasswordField].typeText(confirmPasswordSignup)
        }
    }
        
    private func tapSignupButton() {
        XCTContext.runActivity(named: "Нажатие кнопки Sign Up") { _ in
            app.buttons[Locators.Signup.signupButton].tap()
        }
    }
    
    func fillAndSubmitSignupForm(
        username: String,
        password: String,
        confirmPassword: String
    ) {
        XCTContext.runActivity(named: "Заполенение и отправка формы регистрации") { _ in
            input(usernameSignup: username)
            input(passwordSignup: password)
            input(confirmPasswordSignup: confirmPassword)
            hideKeyboard()
            tapSignupButton()
        }
    }
    
    func waitForSignupScreen() {
        XCTContext.runActivity(named: "Дождаться загрузки экрана Sing up") { _ in
            let _ = app.staticTexts[Locators.Signup.signupButton].waitForExistence(timeout: 10)
        }
    }
    

    
    private func getAlert() -> XCUIElement {
        XCTContext.runActivity(named: "Получение алерта 'Congratulations!'") { _ in
            let _ = app.alerts.firstMatch.waitForExistence(timeout: 10)
            return app.alerts[Locators.Alerts.congratulationsTitle]
        }
    }
    
    func generateRandomUsername() -> String {
        XCTContext.runActivity(named: "Генерация имени пользователя") { _ in
            return "user_" + String(UUID().uuidString.prefix(8))
        }
    }

    func generateRandomPassword() -> String {
        XCTContext.runActivity(named: "Генерация пароля") { _ in
            return String(Int(Date().timeIntervalSince1970))
        }
    }
    
    func tapAlertLogInButton() {
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
    
    func assertUsernameSignupScreenPrefilled(username: String) {
        XCTContext.runActivity(named: "Проверка предзаполнения поля username на экране Sign Up") { _ in
            let usernameField = app.textFields[Locators.Signup.usernameField]
            XCTAssertEqual(usernameField.value as? String, username)
        }

    }
    func assertSecurePasswordSignupScreenPrefilled() {
        XCTContext.runActivity(named: "Проверка предзаполнения поля password на экране Sign Up") { _ in
            let passwordSecureField = app.secureTextFields[Locators.Signup.passwordField]
            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)
        }

    }
    
    func assertPasswordSignupScreenPrefilled(password: String) {
        XCTContext.runActivity(named: "Проверка значения в предзаполненном поле password на экране Sign Up") { _ in
            app.buttons[Locators.Signup.passwordField].tap()
            let passwordField = app.textFields[Locators.Signup.passwordField]
            XCTAssertEqual(passwordField.value as? String, password)
        }
    }
}

class SpendsPage: Page {
    enum Locators {
        enum SpendsPage {
            static let addSpendButton = "addSpendButton"
            static let spendsList = "spendsList"
            static let menuIcon = "ic_menu"
            static let statisticsTitle = "Statistics"
            static let profile = "Profile"
            static let menu = "Menu"
        }
    }
    
    func clickNewSpend() {
        app.buttons[Locators.SpendsPage.addSpendButton].tap()
    }
    
    func clickMenu() {
        app.images[Locators.SpendsPage.menuIcon].tap()
        waitMenu()
    }
    
    func clickProfile() {
        app.buttons[Locators.SpendsPage.profile].tap()
    }
    
    func waitMenu() {
        let _ = app.staticTexts[Locators.SpendsPage.menu].firstMatch.waitForExistence(timeout: 10)
    }

    func assertAddedSpendIsShown(title: String, category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка добавленной траты в списке трат") { _ in
            let titleExists = app.otherElements[Locators.SpendsPage.spendsList].staticTexts[title].waitForExistence(timeout: 1)
            XCTAssertTrue(titleExists, "Описание добавленной траты '\(title)' не отображено", file: file, line: line)

            let categoryExists = app.otherElements[Locators.SpendsPage.spendsList].staticTexts[category].waitForExistence(timeout: 1)
            XCTAssertTrue(categoryExists, "Категория '\(category)' не отображена для добавленной траты", file: file, line: line)
        }
    }
    
    func assertSpendsViewAppeared() {
        XCTContext.runActivity(named: "Ожидание появления экрана 'Spends'") { _ in
            waitForSpendsScreen()
        }
    }
    
    func waitForSpendsScreen(file: StaticString = #filePath, line: UInt = #line) {
        let isFound = app.images[Locators.SpendsPage.menuIcon].firstMatch.waitForExistence(timeout: 10)
        XCTAssert(isFound, "Не дождались экрана 'Spends'", file: file, line: line)
    }
}

class NewSpendPage: Page {
    enum Locators {
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
    
    func inputAmount(amount: String) {
        app.textFields[Locators.SpendForm.amountField].typeText(amount)
    }
    
    func inputDescription(description: String) {
        app.textFields[Locators.SpendForm.descriptionField].tap()
        app.textFields[Locators.SpendForm.descriptionField].typeText(description)
    }
    
    func clickSelectCategory() {
        app.buttons[Locators.SpendForm.selectCategoryButton].tap()
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
            alert.buttons[Locators.SpendForm.addCategoryConfirmButton].firstMatch.tap()
        }
    }
    
    func clickAddSpend() {
        app.buttons[Locators.SpendForm.addSpendButton].tap()
    }
    
    func fillAndSubmitSpendForm(amount: String, title: String, category: String) {
        inputAmount(amount: amount)
        inputDescription(description: title)
        selectCategory(category: category)
        clickAddSpend()
    }
    
    func assertDeletedCategoryNotShown(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка добавленной траты в списке трат") { _ in
            let categoryButton = app.collectionViews.buttons[category]
            XCTAssertFalse(categoryButton.exists, "Категория \(category) всё ещё отображается, но должна быть удалена", file: file, line: line)
        }
    }
}

class ProfilePage: Page {
    enum Locators {
        enum Profile {
            static let close = "Close"
            static let delete = "Delete"
        }
    }
    
    func waitForProfileScreen() {
        XCTContext.runActivity(named: "Ожидание экрана Profile") { _ in
            let _ = app.staticTexts[Locators.Profile.close].firstMatch.waitForExistence(timeout: 10)
        }
    }
    
    func swipeCategory(category: String) {
        XCTContext.runActivity(named: "Свайп по категории \(category)") { _ in
            app.cells.containing(.staticText, identifier: category).firstMatch.swipeLeft()
        }
    }
    
    func clickDelete() {
        XCTContext.runActivity(named: "Нажатие кнопки удалить") { _ in
            app.buttons[Locators.Profile.delete].tap()
        }
    }
    
    func clickClose() {
        app.buttons[Locators.Profile.close].tap()
    }
    
    func assertAddedCategoryInSpendShown(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка отображения на экране Profile категории, добавленной на экране NewSpend") { _ in
            let categoryCell = app.staticTexts[category].firstMatch
            XCTAssertTrue(categoryCell.exists, "Ячейка категории \(category) не найдена", file: file, line: line)
        }
    }
}

class TestCase: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        launchAppWithoutLogin()
    }
    
    func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запуск приложения в режиме 'без авторизации'") { _ in
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
}

extension TestCase {
    func signupAndLogin() {
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
        loginPage.tapLoginButton()
        
        let spendsPage = SpendsPage(app: app)
        spendsPage.assertSpendsViewAppeared()
    }
    
    func addNewCategory() -> String {
        let spendsPage = SpendsPage(app: app)
        spendsPage.clickNewSpend()
        let newSpendPage = NewSpendPage(app: app)
        let amount = "15"
        let title = UUID().uuidString
        let category = String(UUID().uuidString.prefix(5))
        newSpendPage.fillAndSubmitSpendForm(amount: amount, title: title, category: category)
        spendsPage.waitForSpendsScreen()
        return category
    }
}
