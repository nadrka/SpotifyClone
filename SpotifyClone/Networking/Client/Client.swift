import Foundation
import Combine

enum ApiError: Error {
    case cannotDecodeOutput(error: Error)
    case cannotEncodeInput
    case noData
    case invalidPath
    case other(error: Error)
    case noToken
    case unknown
}

typealias CompletionHandler<Value> = (Result<Value, ApiError>) -> Void

protocol Client: class {
    var baseUrl: String { get }
    func call<O: Decodable>(type: O.Type, endpoint: Endpoint) -> AnyPublisher<O, ApiError>
}

extension Client {
    
    public func call<O: Decodable>(type: O.Type, endpoint: Endpoint) -> AnyPublisher<O, ApiError>{
        
        guard let request = createUrlRequest(for: endpoint) else {
            return Fail(error: ApiError.invalidPath)
                .eraseToAnyPublisher()
        }
        
        if endpoint.authorizationNeeded {
            return AuthManager.shared.withValidToken()
                .mapError { _ in
                    ApiError.noToken
                }.flatMap { [weak self] (token: String) in
                    return self?.performDataTask(request: request, with: token) ??
                        Fail(error: ApiError.unknown).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
                
        } else {
            return performDataTask(request: request, with: nil)
        }
        
    }
    
    private func performDataTask<O: Decodable>(request: URLRequest, with token: String?) -> AnyPublisher<O, ApiError> {
        var request = request
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession(configuration: .default)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return session.dataTaskPublisher(for: request)
            .mapError { ApiError.other(error: $0) }
            .map(\.data)
            .mapError { _ in ApiError.noData}
            .decode(type: O.self, decoder: decoder)
            .mapError { error in ApiError.cannotDecodeOutput(error: error) }
            .eraseToAnyPublisher()
        
    }
    
    private func createUrlRequest(for endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.url(with: baseUrl) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let bodyParameters = endpoint.body {
            let data = getHttpBody(bodyParameters: bodyParameters)
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
    
    private func getHttpBody(bodyParameters: Body) -> Data? {
        var components = URLComponents()
        let queryItems = bodyParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems = queryItems
        return components.query?.data(using: .utf8)
    }
}
