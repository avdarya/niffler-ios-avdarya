import XCTest

class SpendsPage: BasePage {
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
    
    @discardableResult
    func clickNewSpend() -> NewSpendPage {
        XCTContext.runActivity(named: "Нажатие кнопки добавления траты") { _ in
            app.buttons[Locators.SpendsPage.addSpendButton].tap()
        }
        return NewSpendPage(app: app)
    }
    
    @discardableResult
    func clickMenu() -> Self {
        XCTContext.runActivity(named: "Нажатие на иконку меню") { _ in
            app.images[Locators.SpendsPage.menuIcon].tap()
            waitMenu()
        }
        return self
    }
    
    @discardableResult
    func clickProfile() -> ProfilePage {
        XCTContext.runActivity(named: "Переход в профиль") { _ in
            app.buttons[Locators.SpendsPage.profile].tap()
        }
        return ProfilePage(app: app)
    }
    
    @discardableResult
    func waitMenu() -> Self {
        XCTContext.runActivity(named: "Ожидание появления меню") { _ in
            let _ = app.staticTexts[Locators.SpendsPage.menu].firstMatch.waitForExistence(timeout: 10)
        }
        return self
    }

    @discardableResult
    func assertAddedSpendIsShown(title: String, category: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка добавленной траты в списке трат") { _ in
            let titleExists = app.otherElements[Locators.SpendsPage.spendsList].staticTexts[title].waitForExistence(timeout: 1)
            XCTAssertTrue(titleExists, "Описание добавленной траты '\(title)' не отображено", file: file, line: line)

            let categoryExists = app.otherElements[Locators.SpendsPage.spendsList].staticTexts[category].waitForExistence(timeout: 1)
            XCTAssertTrue(categoryExists, "Категория '\(category)' не отображена для добавленной траты", file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    func assertSpendsViewAppeared(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидание появления экрана 'Spends'") { _ in
            let isFound = app.images[Locators.SpendsPage.menuIcon].firstMatch.waitForExistence(timeout: 10)
            XCTAssert(isFound, "Не дождались экрана 'Spends'", file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    func assertZeroTotalSpendLabel(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка отображения '0 ₽' в качестве общей суммы трат") { _ in
            let totalLabel = app.staticTexts["0 ₽"].waitForExistence(timeout: 1)
            XCTAssert(totalLabel, file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    func assertEmptySpendList(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверка отображения пустрого списка трат") { _ in
            let spends = app.otherElements.matching(identifier: "spendsList")
            XCTAssertEqual(spends.count, 0, "Ожидали пустой список трат, но нашли \(spends.count)")
        }
        return self
    }
}
