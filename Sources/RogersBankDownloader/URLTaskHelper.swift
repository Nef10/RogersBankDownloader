import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum URLTaskHelper {
    static func processResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<(Data, HTTPURLResponse), DownloadError> {
        guard let data = data else {
            if let error = error {
                return(.failure(DownloadError.httpError(error: error.localizedDescription)))
            } else {
                return(.failure(DownloadError.noDataReceived))
            }
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return(.failure(DownloadError.httpError(error: "No HTTPURLResponse")))
        }
        return(.success((data, httpResponse)))
    }
}
