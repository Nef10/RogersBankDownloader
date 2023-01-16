import Foundation

/// Errors which can happen when getting a Token
public enum DownloadError: Error {
    /// When the received data is not valid JSON
    case invalidJson(error: String)
    /// When the paramters could not be converted to JSON
    case invalidParameters(parameters: [String: String])
    /// When an HTTP error occurs
    case httpError(error: String)
    /// When no data is received from the HTTP request
    case noDataReceived
    /// When trying to download transactions from a non existing statement
    case invalidStatementNumber(_ number: Int)
    /// When parsing a transaction failed because the activity category is not recognized
    case unkownActivityCategory(_ category: String)
}

extension DownloadError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidJson(error):
            return "The server response contained invalid JSON: \(error)"
        case let .invalidParameters(parameters):
            return "The give parameters could not be converted to JSON: \(parameters)"
        case let .httpError(error):
            return "An HTTP error occurred: \(error)"
        case .noDataReceived:
            return "No data was received from the server"
        case let .invalidStatementNumber(number):
            return "\(number) is not a valid statement number to download"
        case let .unkownActivityCategory(category):
            return "Received unknown activity category: \(category)"
        }
    }
}
