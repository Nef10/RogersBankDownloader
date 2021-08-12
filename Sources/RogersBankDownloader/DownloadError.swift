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
}
