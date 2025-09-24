import XCTest

final class SpendsUITests: BaseTestCase {
    
    func testAddedSpendShouldShowInSpendList() {
        // Arrange
        signupAndLogin()
        spendsPage
            .assertSpendsViewAppeared()
            .clickNewSpend()
        
        // Act
        let amount = "14"
        let title = UUID().uuidString
        let category = "Спорт"
        newSpendPage.fillAndSubmitSpendForm(
            amount: amount,
            title: title,
            category: category
        )
        
        // Assert
        spendsPage.assertAddedSpendIsShown(title: title, category: category)
    }
    
    func testNewUserHasEmptySpendList() {
        // Arrange
        
        // Act
        signupAndLogin()
        
        // Assert
        spendsPage
            .assertZeroTotalSpendLabel()
            .assertEmptySpendList()
    }
    
    func testNewUserAddSpendWithCategory() {
        // Arrange
        
        // Act
        signupAndLogin()
        spendsPage
            .assertSpendsViewAppeared()
            .clickNewSpend()
        
        let amount = "15"
        let title = UUID().uuidString
        let category = "Кофе"
        newSpendPage.fillAndSubmitSpendForm(
            amount: amount,
            title: title,
            category: category
        )
        
        // Assert
        spendsPage
            .assertSpendsViewAppeared()
            .assertAddedSpendIsShown(title: title, category: category)
    }
    
    func testDeletedCategoryFromProfileIsNotVisibleInSpendForm() {
        // Arrange
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "12345")
        spendsPage.assertSpendsViewAppeared()
        let category = addNewCategory()
        spendsPage
            .assertSpendsViewAppeared()
            .clickMenu()
            .clickProfile()
        
        // Act
        profilePage
            .waitForProfileScreen()
            .swipeCategory(category: category)
            .clickDelete()
            .clickClose()
        spendsPage.clickNewSpend()
        newSpendPage.clickSelectCategory()
        
        // Assert
        newSpendPage.assertDeletedCategoryNotShown(category: category)
    }
}
