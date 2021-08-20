import Foundation

/// Customer of the bank
public struct Customer: Codable {
    /// Internal ID
    public let customerId: String
    /// Last 4 digits of the credit card
    public let cardLast4: String
    /// Customer Type, e.g. Primary
    public let customerType: String
    /// First name
    public let firstName: String
    /// Last name
    public let lastName: String
}

struct Activities: Codable {
    let activities: [Activity]? // swiftlint:disable:this discouraged_optional_collection
}

/// Merchant
public struct Merchant: Codable {
    /// Name
    public let name: String
    /// 4 digit Merchant Category Code from the payment netrowk
    public let categoryCode: String?
    /// Description for the Merchant Category from the payment netrowk
    public let categoryDescription: String?
    /// Broad category name, used for the icons on the site
    public let category: String
    /// Address of the merchant
    public let address: Address?
}

/// An Address
public struct Address: Codable {
    /// City - for online transactions often not a city
    public let city: String
    /// State or Province
    public let stateProvince: String?
    /// Postal / ZIP Code
    public let postalCode: String
    /// ISO Country code
    public let countryCode: String
}

/// Info about a transaction in an foreign currency
public struct ForeignCurrency: Codable {
    /// Amount of fee paid
    public let exchangeFee: Amount
    /// Conversion rate after embedding the exchange fee
    public let conversionMarkupRate: Float
    /// Official conversion rate
    public let conversionRate: Float
    /// Amount in foreign currency
    public let originalAmount: Amount
}

/// An amount of money
public struct Amount: Codable {
    /// Numeric value
    public let value: String
    /// ISO Currency code
    public let currency: String
}

/// Type of a credit card activity
public enum ActivityType: String, Codable {
    /// A transaction which has been posted
    case transaction = "TRANS"
    /// A pre authorization which has not been posted
    case authorization = "AUTH"
}

/// Status of a credit card transaction
public enum ActivityStatus: String, Codable {
    /// The transaction has been approved and posted
    case approved = "APPROVED"
    /// The transaction is still pending
    case pending = "PENDING"
}

/// Categorization for a credit card transaction
public enum ActivityCategory: String, Codable {
    /// A Purchase, inclduing a refund
    case purchase = "PURCHASE"
    /// A Payment towards the balance
    case payment = "PAYMENT"
    /// A pre authorization for a purchase
    case tokenAuthRequest = "Token Auth Request"
    /// An authorization for an mail or phone order
    case mailOrPhoneOrder = "Mail or Phone Order"
}

/// An activity on the credit card, like a authorization, transactions or payment
public struct Activity: Codable {

    /// Reference number for posted transactions
    public let referenceNumber: String?
    /// Activity type, e.g. Transaction or Authorization
    public let activityType: ActivityType
    /// Amount charged - if transaction was in foreign currency, see foreign for the original amount
    public let amount: Amount
    /// Status of the transaction, e.g. approved or pending
    public let activityStatus: ActivityStatus
    /// Category, e.g. Purchase, Payment for Authorization
    public let activityCategory: ActivityCategory
    /// Activity classification
    public let activityClassification: String
    /// Card Number with all but the last 4 digits replaced with *
    public let cardNumber: String
    /// Merchant
    public let merchant: Merchant
    /// Foreign currency information if the transaction was in one
    public let foreign: ForeignCurrency?
    /// Date of the transaction
    public let date: Date
    /// Activity Category Code
    public let activityCategoryCode: String?
    /// Customer ID, see Customer.customerId
    public let customerId: String
    /// If the transaction is posted, the date of the posting
    public let postedDate: Date?
    /// Activity Id for pending transactions
    public let activityId: String?
}
