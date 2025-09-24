import XCTest

class NewSpendPage: BasePage {
    enum Locators {
        enum SpendForm {
            static let amountField = "amountField"
            static let descriptionField = "descriptionField"
            static let selectCategoryButton = "Select category"
            static let addCategoryAlert = "Add category"
            static let addCategoryNameField = "Name"
            static let addCategoryConfirmButton = "Add"
            static let newCategoryButton = "+ New category"
            static let addSpendButton = "Add"
        }
    }
    
    func inputAmount(amount: String) {
        XCTContext.runActivity(named: "Ввод суммы \(amount)") { _ in
            app.textFields[Locators.SpendForm.amountField].typeText(amount)
        }
    }
    
    func inputDescription(description: String) {
        XCTContext.runActivity(named: "Ввод описания \(description)") { _ in
            app.textFields[Locators.SpendForm.descriptionField].tap()
            app.textFields[Locators.SpendForm.descriptionField].typeText(description)
        }
    }
    
    func clickSelectCategory() {
        XCTContext.runActivity(named: "Нажатие кнопки выбора категории") { _ in
            app.buttons[Locators.SpendForm.selectCategoryButton].tap()
        }
    }
    
    @discardableResult
    func clickAddSpend() -> SpendsPage {
        XCTContext.runActivity(named: "Нажатие кнопки добавления траты") { _ in
            app.buttons[Locators.SpendForm.addSpendButton].tap()
        }
        return SpendsPage(app: app)
    }
    
    func selectCategory(category: String) {
        XCTContext.runActivity(named: "Выбор категории \(category)") { _ in
            app.buttons[Locators.SpendForm.selectCategoryButton].tap()
            // 1. Если сразу появился алерт "Add category" — вводим и подтверждаем категорию
            let addCategoryAlert = app.alerts[Locators.SpendForm.addCategoryAlert]
            if addCategoryAlert.waitForExistence(timeout: 1) {
                let nameField = addCategoryAlert.textFields[Locators.SpendForm.addCategoryNameField]
                if nameField.waitForExistence(timeout: 1) {
                    nameField.tap()
                    nameField.typeText(category)
                }
                addCategoryAlert.buttons[Locators.SpendForm.addCategoryConfirmButton].firstMatch.tap()
                return
            }
            // 2. Если категория уже существует — выбираем её
            let existingCategoryButton = app.buttons[category]
            if existingCategoryButton.waitForExistence(timeout: 1) {
                existingCategoryButton.tap()
                return
            }
            // 3. Если категории нет, но есть список — жмём + New category, вводим и подтверждаем
            let newCategoryButton = app.buttons[Locators.SpendForm.newCategoryButton]
            if newCategoryButton.waitForExistence(timeout: 1) {
                newCategoryButton.tap()
                let alert = app.alerts[Locators.SpendForm.addCategoryAlert]
                let nameField = alert.textFields[Locators.SpendForm.addCategoryNameField]
                if nameField.waitForExistence(timeout: 1) {
                    nameField.tap()
                    nameField.typeText(category)
                }
                alert.buttons[Locators.SpendForm.addCategoryConfirmButton].firstMatch.tap()
            }
        }
    }

    func fillAndSubmitSpendForm(amount: String, title: String, category: String) {
        XCTContext.runActivity(named: "Заполнение и отправка формы добавления траты") { _ in
            inputAmount(amount: amount)
            inputDescription(description: title)
            selectCategory(category: category)
            clickAddSpend()
        }
    }
    
    func assertDeletedCategoryNotShown(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверка добавленной траты в списке трат") { _ in
            let categoryButton = app.collectionViews.buttons[category]
            XCTAssertFalse(categoryButton.exists, "Категория \(category) всё ещё отображается, но должна быть удалена", file: file, line: line)
        }
    }
}
