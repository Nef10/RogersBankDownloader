import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// An online user account
public struct User: Codable {

    private static var startURL = URL(string: "https://rbaccess.rogersbank.com/?product=ROGERSBRAND")!
    private static var authenticationURL = URL(string: "https://rbaccess.rogersbank.com/issuing/digital/authenticate/user")!

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    private static let authenticationRequest: URLRequest = {
        var request = URLRequest(url: authenticationURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("ROGERSBRAND", forHTTPHeaderField: "Brand_id")
        request.setValue("json", forHTTPHeaderField: "Datatype")
        request.setValue("web", forHTTPHeaderField: "Sourcetype")
        return request
    }()

    /// User name used to login
    public let userName: String
    /// Credit Card Accounts the user has access to
    public let accounts: [Account]
    /// Authenticated
    public let authenticated: Bool

    /// Login and load a user account
    /// - Parameters:
    ///   - username: user name
    ///   - password: password
    ///   - deviceId: device id to skip 2FA
    ///   - deviceInfo: device info to skip 2FA
    ///   - completion: completion handler, returns the User or a Download Error
    public static func load(username: String, password: String, deviceId: String, deviceInfo: String, completion: @escaping (Result<User, DownloadError>) -> Void) {
        sendStartRequest {
            if let error = $0 {
                completion(.failure(error))
                return
            } else {
                let parameters = [
                    "username": username,
                    "password": password,
                    "deviceId": deviceId,
                    "deviceInfo": deviceInfo
                ]
                sendAuthenticationRequest(parameters: parameters) {
                    completion($0)
                }
            }
        }
    }

    private static func sendStartRequest(completion: @escaping (DownloadError?) -> Void) {
        var request = URLRequest(url: startURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                if let error = error {
                    completion(DownloadError.httpError(error: error.localizedDescription))
                } else {
                    completion(DownloadError.noDataReceived)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(DownloadError.httpError(error: "No HTTPURLResponse"))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(DownloadError.httpError(error: "Status code \(httpResponse.statusCode)"))
                return
            }
            completion(nil)
        }
        task.resume()
    }

    private static func sendAuthenticationRequest(parameters: [String: String], completion: @escaping (Result<User, DownloadError>) -> Void) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(DownloadError.invalidParameters(parameters: parameters)))
            return
        }

        let task = URLSession.shared.uploadTask(with: authenticationRequest, from: jsonData) { data, response, error in
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
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(DownloadError.invalidJson(error: String(describing: error))))
            }
        }
        task.resume()
    }
}
