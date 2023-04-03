import UIKit

struct Request {
    typealias RequestParams = [String: Any]

    let query: String
    let method: RequestMethod
    let bodyParameters: RequestParams?

    init(query: String, method: RequestMethod, bodyParameters: RequestParams? = nil) {
        self.query = query
        self.method = method
        self.bodyParameters = bodyParameters
    }
}

extension Request {
    enum RequestMethod: String {
        case get
        case post
        case delete
        case put
    }
}
