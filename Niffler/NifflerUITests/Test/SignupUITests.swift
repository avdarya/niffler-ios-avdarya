import XCTest

final class SignupUITests: BaseTestCase {
        
    func testRegistration() throws {
        // Arrange
        loginPage.tapCreateNewAccountButton()
        
        // Act
        let randomUsername = signupPage.generateRandomUsername()
        let randomPassword = signupPage.generateRandomPassword()
        signupPage.fillAndSubmitSignupForm(
            username: randomUsername,
            password: randomPassword,
            confirmPassword: randomPassword
        )
        
        // Assert
        signupPage.assertSuccessAlertShown()
    }
    
    func testSignUpPrefilledData() throws {
        // Act
        let randomUsername = signupPage.generateRandomUsername()
        let randomPassword = signupPage.generateRandomPassword()
        loginPage
            .input(login: randomUsername)
            .input(password: randomPassword)
            .hideKeyboard()
            .tapCreateNewAccountButton()
            
        signupPage.waitForSignupScreen()
        
        // Assert
        signupPage.assertSignupScreenPrefilled(
            username: randomUsername,
            password: randomPassword
        )
    }
}
