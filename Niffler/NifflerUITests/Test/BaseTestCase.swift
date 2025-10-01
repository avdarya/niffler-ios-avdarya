import XCTest

class BaseTestCase: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        launchAppWithoutLogin()
    }
    
    override func tearDown() {
        app = nil
        loginPage = nil
        signupPage = nil
        spendsPage = nil
        profilePage = nil
        super.tearDown()
    }
    
    lazy var loginPage: LoginPage! = LoginPage(app: app)
    lazy var signupPage: SignupPage! = SignupPage(app: app)
    lazy var spendsPage: SpendsPage! = SpendsPage(app: app)
    lazy var profilePage: ProfilePage! = ProfilePage(app: app)
    lazy var newSpendPage: NewSpendPage! = NewSpendPage(app: app)

    
    func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запуск приложения в режиме 'без авторизации'") { _ in
            if
                ProcessInfo.processInfo.arguments
                    .contains("RemoveAuthOnStart") {
                app.launchArguments = ["RemoveAuthOnStart"]
                app.launch()
            }
        }
    }
}

extension BaseTestCase {
    func signupAndLogin() {
        loginPage.tapCreateNewAccountButton()
        
        let randomUsername = signupPage.generateRandomUsername()
        let randomPassword = signupPage.generateRandomPassword()
        signupPage
            .fillAndSubmitSignupForm(
                username: randomUsername,
                password: randomPassword,
                confirmPassword: randomPassword
            )
        signupPage.tapAlertLogInButton()

        loginPage
            .waitForLoginScreen()
            .tapLoginButton()
        
        spendsPage.assertSpendsViewAppeared()
    }
    
    func addNewCategory() -> String {
        spendsPage.clickNewSpend()
        let amount = "15"
        let title = UUID().uuidString
        let category = String(UUID().uuidString.prefix(5))
        newSpendPage.fillAndSubmitSpendForm(amount: amount, title: title, category: category)
        spendsPage.assertSpendsViewAppeared()
        return category
    }
}
