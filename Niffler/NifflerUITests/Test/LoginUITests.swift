import XCTest

final class LoginUITests: BaseTestCase {
        
    func testLoginSuccessful() throws {
        // Arrange
        
        // Act
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "12345")
        
        // Assert
        spendsPage.assertSpendsViewAppeared()
    }
    
    func testLoginFailure() throws {
        // Arrange
        
        // Act
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "123456")
        
        // Assert
        loginPage.assertErrorLoginShown()
    }
    
    func testLoginPrefilledData() throws {
        // Arrange
        loginPage.tapCreateNewAccountButton()
        
        // Act
        let randomUsername = signupPage.generateRandomUsername()
        let randomPassword = signupPage.generateRandomPassword()
        signupPage
            .fillAndSubmitSignupForm(
                username: randomUsername,
                password: randomPassword,
                confirmPassword: randomPassword
            )
            .tapAlertLogInButton()
        loginPage.waitForLoginScreen()
        
        // Assert
        loginPage.assertLoginScreenPrefilled(
            username: randomUsername,
            password: randomPassword
        )
    }
}
