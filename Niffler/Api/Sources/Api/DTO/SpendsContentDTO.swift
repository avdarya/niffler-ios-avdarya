import Foundation

public struct SpendsDTO: Decodable {
    public let content: [Spends]
}

import SwiftData

public struct Spends: Identifiable, Codable, Hashable {
    public init(id: String?, spendDate: Date?, category: CategoryDTO, currency: String, amount: Double, description: String, username: String) {
        self.id = id
        self.spendDate = spendDate
        self.category = category
        self.currency = currency
        self.amount = amount
        self.description = description
        self.username = username
    }
    
    // MARK: - Codable
    /// New spend has no id until response from backend
    public let id: String?
    public let spendDate: Date?
    public let category: CategoryDTO
    public let currency: String
    public let amount: Double
    public let description: String
    public let username: String
    
    // MARK: - Model
    public var dateForSort: Date {
        spendDate ?? Date()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Spends {
    public var amountStringForUI: String {
        Self.amountFormatterWithDigits.string(from: .init(value: amount)) ?? ""
    }
    
    public var amountStringSpellOut: String {
        Self.amountFormatterSpellOut.string(from: .init(value: amount)) ?? ""
    }
    
    static var amountFormatterWithDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static var amountFormatterSpellOut: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    public var spendDateDescription: String {
        spendDate.map(DateFormatterHelper.shared.formatForUser) ?? "No data"
    }
}
