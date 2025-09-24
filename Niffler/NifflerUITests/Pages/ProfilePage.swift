import XCTest

class ProfilePage: BasePage {
    enum Locators {
        enum Profile {
            static let close = "Close"
            static let delete = "Delete"
        }
    }
    
    @discardableResult
    func waitForProfileScreen() -> Self {
        XCTContext.runActivity(named: "Ожидание экрана Profile") { _ in
            let _ = app.staticTexts[Locators.Profile.close].firstMatch.waitForExistence(timeout: 10)
        }
        return self
    }
    
    @discardableResult
    func swipeCategory(category: String) -> Self {
        XCTContext.runActivity(named: "Свайп по категории \(category)") { _ in
            app.cells.containing(.staticText, identifier: category).firstMatch.swipeLeft()
        }
        return self
    }
    
    @discardableResult
    func clickDelete() -> Self {
        XCTContext.runActivity(named: "Нажатие кнопки Delete") { _ in
            app.buttons[Locators.Profile.delete].tap()
        }
        return self
    }
    
    @discardableResult
    func clickClose() -> SpendsPage {
        XCTContext.runActivity(named: "Нажатие кнопки Close") { _ in
            app.buttons[Locators.Profile.close].tap()
        }
        return SpendsPage(app: app)
    }
    
    func assertAddedCategoryInSpendShown(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка отображения на экране Profile категории, добавленной на экране NewSpend") { _ in
            let categoryCell = app.staticTexts[category].firstMatch
            XCTAssertTrue(categoryCell.exists, "Ячейка категории \(category) не найдена", file: file, line: line)
        }
    }
}
