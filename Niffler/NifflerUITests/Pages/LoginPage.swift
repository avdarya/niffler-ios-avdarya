import XCTest

class LoginPage: BasePage {
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
    
    @discardableResult
    func input(login: String) -> Self  {
        XCTContext.runActivity(named: "Ввод логина \(login)") { _ in
            app.textFields[Locators.Login.usernameField].tap()
            app.textFields[Locators.Login.usernameField].typeText(login)
        }
        return self
    }
    
    @discardableResult
    func input(password: String) -> Self {
        XCTContext.runActivity(named: "Ввод пароля \(password)") { _ in app.secureTextFields[Locators.Login.passwordField].tap()
            app.secureTextFields[Locators.Login.passwordField].typeText(password)
        }
        return self
    }
    
    @discardableResult
    func tapLoginButton() -> SpendsPage {
        XCTContext.runActivity(named: "Нажатие кнопки Log in") { _ in
            app.buttons[Locators.Login.loginButton].tap()
        }
        return SpendsPage(app: app)
    }
    
    func fillAndSubmitLoginForm(login: String, password: String) {
        XCTContext.runActivity(named: "Заполнение и отправка формы авторизации") { _ in
            input(login: login)
            input(password: password)
            tapLoginButton()
        }
    }
    
    @discardableResult
    func tapCreateNewAccountButton() -> SignupPage {
        XCTContext.runActivity(named: "Нажатие кнопки Create new account") { _ in
            app.staticTexts[Locators.Login.createNewAccountButton].tap()
        }
        return SignupPage(app: app)
    }
    
    func tapTogglePassword() {
        XCTContext.runActivity(named: "Нажатие кнопки показа/скрытия пароля") { _ in
            app.buttons[Locators.Login.passwordField].tap()
        }
    }
    
    @discardableResult
    func waitForLoginScreen() -> Self {
        XCTContext.runActivity(named: "Ожидание экрана Log in") { _ in
            let _ = app.staticTexts[Locators.Login.loginTitle].firstMatch.waitForExistence(timeout: 10)
        }
        return self
    }
    
    @discardableResult
    func assertErrorLoginShown(file: StaticString = #filePath, line: UInt = #line)  -> Self {
        XCTContext.runActivity(named: "Ожидание появления сообщения об ошибке авторизации") { _ in
            let isFound = app.staticTexts[Locators.Login.loginErrorMessage].waitForExistence(timeout: 10)
            XCTAssertTrue(
                isFound,
                "Не нашли сообщение об ошибке о неправильном логине",
                file: file,
                line: line
            )
        }
        return self
    }
    
    @discardableResult
    func assertLoginScreenPrefilled(username: String, password: String) -> Self {
        XCTContext.runActivity(named: "Проверка предзаполненных полей экрана Log In") { _ in
            // username
            let usernameField = app.textFields[Locators.Login.usernameField]
            XCTAssertEqual(usernameField.value as? String, username)

            // secure password (•••••)
            let passwordSecureField = app.secureTextFields[Locators.Login.passwordField]
            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)

            // revealed password
            tapTogglePassword()
            let passwordField = app.textFields[Locators.Login.passwordField]
            XCTAssertEqual(passwordField.value as? String, password)
        }
        return self
    }
    
//    func assertUsernameLoginScreenPrefilled(username: String) -> Self {
//        XCTContext.runActivity(named: "Проверка предзаполнения поля username на экране Log In") { _ in
//            let usernameField = app.textFields[Locators.Login.usernameField]
//            XCTAssertEqual(usernameField.value as? String, username)
//        }
//        return self
//    }
//    
//    @discardableResult
//    func assertSecurePasswordLoginScreenPrefilled() -> Self {
//        XCTContext.runActivity(named: "Проверка предзаполнения поля password на экране Log In") { _ in
//            let passwordSecureField = app.secureTextFields[Locators.Login.passwordField]
//            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)
//        }
//        return self
//    }
    
//    enum PasswordVisibility {
//        case secure
//        case revealed
//    }
//    
//    @discardableResult
//    func assertPasswordPrefilled(password: String, visibility: PasswordVisibility) -> Self {
//        XCTContext.runActivity(named: "Проверка предзаполнения поля password на экране Log In") { _ in
//            switch visibility {
//            case .secure:
//                let passwordSecureField = app.secureTextFields[Locators.Login.passwordField]
//                XCTAssertTrue(
//                    (passwordSecureField.value as? String)?.contains("•") == true)
//            case .revealed:
//                tapTogglePassword()
//                let passwordField = app.textFields[Locators.Login.passwordField]
//                XCTAssertEqual(passwordField.value as? String, password)
//            }
//        }
//        return self
//    }
//    
//    @discardableResult
//    func assertPasswordLoginScreenPrefilled(password: String) -> Self {
//        XCTContext.runActivity(named: "Проверка значения в предзаполненном поле password на экране Log In") { _ in
//            tapTogglePassword()
//            let passwordField = app.textFields[Locators.Login.passwordField]
//            XCTAssertEqual(passwordField.value as? String, password)
//        }
//        return self
//    }
}
