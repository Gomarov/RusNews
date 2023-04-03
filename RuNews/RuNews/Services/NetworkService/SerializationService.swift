import Foundation

protocol SerializationServiceProtocol {
    func serialize<T: Encodable>(_ value: T) throws -> Data
    func deserialize<T: Decodable>(_ data: Data) throws -> T
}

final class SerializationService {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.keyEncodingStrategy = .convertToSnakeCase
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
    }
}

extension SerializationService: SerializationServiceProtocol {

    func serialize<T>(_ value: T) throws -> Data where T: Encodable {
        return try encoder.encode(value)
    }

    func deserialize<T>(_ data: Data) throws -> T where T: Decodable {
        return try decoder.decode(T.self, from: data)
    }

}
