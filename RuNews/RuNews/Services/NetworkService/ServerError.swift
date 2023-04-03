import Foundation

enum ServerError: Error {
    static let parametersMissingCode = "parametersMissing"

    case invalidResponse(underlyingError: ApiError)
    case invalidURL
}

struct ApiError: Decodable {
    let status: String
    let code: String
    let message: String
}
