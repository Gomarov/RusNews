import Foundation
import RxCocoa
import RxSwift

protocol NetworkServiceProtocol {
    func data<T: Decodable>(for request: Request) -> Single<T>
    func data(for request: Request) -> Single<Data>
}

final class NetworkService: NetworkServiceProtocol {
    
    private let serializationService: SerializationServiceProtocol
    private lazy var httpHeaders: [String: String] = {
        var headers: [String: String] = [
            "Content-Type": "application/json; charset=utf-8",
            "X-Api-Key": Constants.apiKey]
        return headers
    }()

    init(serializationService: SerializationServiceProtocol) {
        self.serializationService = serializationService
    }

    // MARK: - Private methods
    private func makeSessionRequest(from request: Request) throws -> URLRequest {
        let urlString = [Constants.newsApiEndpoint, request.query].joined(separator: "/")
        guard let url = URL(string: urlString) else {
            #if DEBUG_NETWORK_INTERACTION
            print("Session query url failed: base \(apiBase) and query \(request.query)")
            #endif
            throw ServerError.invalidURL
        }

        var sessionRequest = URLRequest(url: url)
        sessionRequest.httpMethod = request.method.rawValue
        sessionRequest.allHTTPHeaderFields = httpHeaders

        return sessionRequest
    }

    private func performRequest<T: Decodable>(request: Request) -> Single<T> {
        guard let sessionRequest = try? makeSessionRequest(from: request) else {
            return .error(ServerError.invalidURL)
        }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20
        sessionConfig.timeoutIntervalForResource = 20

        return URLSession(configuration: sessionConfig).rx.response(request: sessionRequest)
            .flatMap { [unowned self] response, data -> Observable<T> in
                let responseString = String(data: data, encoding: .utf8)
                #if DEBUG_NETWORK_RESPONSE
                print("StatusCode: \(response.statusCode)")
                print("\n URL: \(sessionRequest.url?.absoluteString ?? "") \nResponse: \n\(responseString ?? "")\n")
                #endif
                do {
                    let successData: T = try self.serializationService.deserialize(data)
                    return Observable.just(successData)
                } catch let deserializationError {
                    #if DEBUG_NETWORK_INTERACTION
                    print(deserializationError.localizedDescription)
                    #endif
                    if let error = try? JSONDecoder().decode(ApiError.self, from: data) {
                        return Observable.error(ServerError.invalidResponse(underlyingError: error))
                    }
                    return Observable.error(deserializationError)
                }
            }.asSingle()
    }

}

// MARK: - NetworkServiceProtocol
extension NetworkService {
    func data<T: Decodable>(for request: Request) -> Single<T> {
        return performRequest(request: request)
    }
}
