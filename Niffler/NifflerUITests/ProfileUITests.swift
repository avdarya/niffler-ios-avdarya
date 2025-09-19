//
//  ProfileUITests.swift
//  Niffler
//
//  Created by Дарья Цыденова on 19.09.2025.
//
import XCTest

final class ProfileUITests: TestCase {
    
    func testNewCategoryFromSpendFormIsVisibleInProfile() {
        let loginPage = LoginPage(app: app)
        loginPage.fillAndSubmitLoginForm(login: "stage", password: "12345")
        
        let spendsPage = SpendsPage(app: app)
        spendsPage.assertSpendsViewAppeared()
        spendsPage.clickNewSpend()
        
        let newSpendPage = NewSpendPage(app: app)
        let amount = "15"
        let title = UUID().uuidString
        let category = String(UUID().uuidString.prefix(5))
        newSpendPage.fillAndSubmitSpendForm(amount: amount, title: title, category: category)
        
        spendsPage.waitForSpendsScreen()
        spendsPage.clickMenu()
        spendsPage.clickProfile()
        
        let profilePage = ProfilePage(app: app)
        profilePage.waitForProfileScreen()
        
        profilePage.assertAddedCategoryInSpendShown(category: category)
    }
    
}

