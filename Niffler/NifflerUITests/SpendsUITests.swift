//
//  NifflerUITests.swift
//  NifflerUITests
//
//  Created by Дарья Цыденова on 11.09.2025.
//
import XCTest

final class SpendsUITests: TestCase {
    
    func testAddedSpendShouldShowInSpendList() {
        signupAndLogin()
        
        let spendsPage = SpendsPage(app: app)
        spendsPage.waitForSpendsScreen()
        spendsPage.clickNewSpend()
        
        let newSpendPage = NewSpendPage(app: app)

        let amount = "14"
        let title = UUID().uuidString
        let category = "Спорт"
        newSpendPage.fillAndSubmitSpendForm(amount: amount, title: title, category: category)
        
        spendsPage.assertAddedSpendIsShown(title: title, category: category)
    }
    
    func testNewUserHasEmptySpendList() {
        signupAndLogin()

        let totalLabel = app.staticTexts["0 ₽"].waitForExistence(timeout: 1)
        XCTAssert(totalLabel)
        let spends = app.otherElements.matching(identifier: "spendsList")
        XCTAssertEqual(spends.count, 0, "Ожидали пустой список трат, но нашли \(spends.count)")
    }
    
    func testNewUserAddSpendWithCategory() {
        signupAndLogin()
        
        let spendsPage = SpendsPage(app: app)
        spendsPage.assertSpendsViewAppeared()
        spendsPage.clickNewSpend()
        let newSpendPage = NewSpendPage(app: app)
        let amount = "15"
        let title = UUID().uuidString
        let category = "Кофе"
        newSpendPage.fillAndSubmitSpendForm(amount: amount, title: title, category: category)
        spendsPage.assertSpendsViewAppeared()
        spendsPage.assertAddedSpendIsShown(title: title, category: category)
    }
    
    func testDeletedCategoryFromProfileIsNotVisibleInSpendForm() {
        let loginPage = LoginPage(app: app)
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "12345")
        
        let spendsPage = SpendsPage(app: app)
        spendsPage.waitForSpendsScreen()
        
        let category = addNewCategory()

        spendsPage.clickMenu()
        spendsPage.clickProfile()
        
        let profilePage = ProfilePage(app: app)
        profilePage.waitForProfileScreen()
        
        profilePage.swipeCategory(category: category)
        profilePage.clickDelete()
        profilePage.clickClose()
        
        spendsPage.clickNewSpend()
        
        let newSpendPage = NewSpendPage(app: app)
        newSpendPage.clickSelectCategory()
        newSpendPage.assertDeletedCategoryNotShown(category: category)
    }
}
