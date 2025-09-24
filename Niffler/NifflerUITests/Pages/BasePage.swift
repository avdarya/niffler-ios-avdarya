import XCTest

class BasePage {
    init(app: XCUIApplication) {
        self.app = app
    }
    
    let app: XCUIApplication
    
    @discardableResult
    func hideKeyboard() -> Self {
        XCTContext.runActivity(named: "Скрытие клавиатуры") { _ in
            app.keyboards.buttons["Return"].tap()
        }
        return self
    }
}
