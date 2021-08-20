import Foundation

/// List of available statements
struct Statements: Codable {
    /// Statements
    let monthlyStatements: [Statement]
}

/// A Statement
public struct Statement: Codable {
    /// Type, e.g. monthly
    public let statementType: String
    /// ID of the statement
    public let statementId: String
    /// Date the statement was generated
    public let statementDate: Date
    /// Date the statement cycle ended
    public let cycleDate: Date
    /// Last 4 digits of the credit card number
    public let cardLast4: String
}
