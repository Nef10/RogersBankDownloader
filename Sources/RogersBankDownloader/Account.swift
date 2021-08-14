import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A credit card account
public struct Account: Codable {

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    /// Customer
    public let customer: Customer
    /// Internal ID
    public let accountId: String
    /// Account type, e.g. Personal
    public let accountType: String
    /// Payment status, e.g. Paid
    public let paymentStatus: String
    /// Product Name, e.g. World Elite
    public let productName: String
    /// Code for product
    public let productExternalCode: String
    /// ISO symbol of account currency
    public let accountCurrency: String
    /// Brand name, e.g. ROGERSBRAND
    public let brandId: String
    /// Date the Account was opend
    public let openedDate: Date
    /// Date of the last statement
    public let previousStatementDate: Date
    /// Date the payment of the current statement is due (might be in the past)
    public let paymentDueDate: Date
    /// Date of the last payment
    public let lastPaymentDate: Date
    /// List of past statement dates
    public let cycleDates: [Date]
    /// Current balance
    public let currentBalance: Amount
    /// Balance on the last Statement
    public let statementBalance: Amount
    /// Amount which is still due for the statement
    public let statementDueAmount: Amount
    /// Credit limit
    public let creditLimit: Amount
    /// Amount charged since the last statement
    public let purchasesSinceLastCycle: Amount
    /// Amount of the last payment
    public let lastPayment: Amount
    /// Remaining credit limit
    public let realtimeBalance: Amount
    /// Cash Advance available
    public let cashAvailable: Amount
    /// Cash Advance limit
    public let cashLimit: Amount
    /// Multi Card
    public let multiCard: Bool

    private var activityURLComponents: URLComponents {
        URLComponents(string: "https://rbaccess.rogersbank.com/issuing/digital/account/\(accountId)/customer/\(customer.customerId)/activity")!
    }

    /// Downloads the transactions
    /// - Parameters:
    ///   - statementNumber: number of the statement for which the transactions should be downloaded, with 0 mean current period, 1 means last statement, ...
    ///   - completion: completion handler, called with either the Transactions or a DownloadError
    public func downloadActivities(statementNumber: Int, completion: @escaping (Result<[Activity], DownloadError>) -> Void) {
        guard statementNumber >= 0 && cycleDates.count >= statementNumber else {
            completion(.failure(DownloadError.invalidStatementNumber(statementNumber)))
            return
        }
        var urlComponents = activityURLComponents
        if statementNumber > 0 {
            urlComponents.queryItems = [URLQueryItem(name: "cycleStartDate", value: Self.dateFormatter.string(from: cycleDates[statementNumber - 1]))]
        }
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(DownloadError.httpError(error: error.localizedDescription)))
                } else {
                    completion(.failure(DownloadError.noDataReceived))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(DownloadError.httpError(error: "No HTTPURLResponse")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(DownloadError.httpError(error: "Status code \(httpResponse.statusCode)")))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)
                let activities = try decoder.decode(Activities.self, from: data)
                completion(.success(activities.activities))
            } catch {
                completion(.failure(DownloadError.invalidJson(error: String(describing: error))))
                return
            }
        }
        task.resume()
    }

}
