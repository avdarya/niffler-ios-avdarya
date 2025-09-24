import XCTest

final class ProfileUITests: BaseTestCase {
    
    func testNewCategoryFromSpendFormIsVisibleInProfile() {
        // Arrange
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "12345")
        spendsPage
            .assertSpendsViewAppeared()
            .clickNewSpend()
        
        // Act
        let amount = "15"
        let title = UUID().uuidString
        let category = String(UUID().uuidString.prefix(5))
        newSpendPage.fillAndSubmitSpendForm(
            amount: amount,
            title: title,
            category: category
        )
        
        spendsPage
            .assertSpendsViewAppeared()
            .clickMenu()
            .clickProfile()
        profilePage.waitForProfileScreen()
        
        // Assert
        profilePage.assertAddedCategoryInSpendShown(category: category)
    }
    
}

