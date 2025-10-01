import XCTest

class SignupPage: BasePage {
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
        
    @discardableResult
    func tapSignupButton() -> Self {
        XCTContext.runActivity(named: "Нажатие кнопки Sign Up") { _ in
            app.buttons[Locators.Signup.signupButton].tap()
        }
        return self
    }
    
    @discardableResult
    func fillAndSubmitSignupForm(
        username: String,
        password: String,
        confirmPassword: String
    ) -> Self {
        XCTContext.runActivity(named: "Заполенение и отправка формы регистрации") { _ in
            input(usernameSignup: username)
            input(passwordSignup: password)
            input(confirmPasswordSignup: confirmPassword)
            hideKeyboard()
            tapSignupButton()
        }
        return self
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
    
    func tapTogglePassword() {
        XCTContext.runActivity(named: "Нажатие кнопки показа/скрытия пароля") { _ in
            app.buttons[Locators.Signup.passwordField].tap()
        }
    }
    
    @discardableResult
    func tapAlertLogInButton() -> LoginPage {
        XCTContext.runActivity(named: "Нажатие кнопки Log in в алерте 'Congratulations!'") { _ in
            let alert = getAlert()
            alert.buttons[Locators.Alerts.loginButton].tap()
        }
        return LoginPage(app: app)
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
    @discardableResult
    func assertSignupScreenPrefilled(username: String, password: String) -> Self {
        XCTContext.runActivity(named: "Проверка предзаполненных полей экрана Sign Up") { _ in
            // username
            let usernameField = app.textFields[Locators.Signup.usernameField]
            XCTAssertEqual(usernameField.value as? String, username)

            // secure password (•••••)
            let passwordSecureField = app.secureTextFields[Locators.Signup.passwordField]
            XCTAssertTrue((passwordSecureField.value as? String)?.contains("•") == true)

            // revealed password
            tapTogglePassword()
            let passwordField = app.textFields[Locators.Signup.passwordField]
            XCTAssertEqual(passwordField.value as? String, password)
        }
        return self
    }

}
