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

struct AccessToken: RawRepresentable, Decodable {
    var rawValue: String
}

struct RefreshToken: RawRepresentable, Decodable {
    var rawValue: String
}

enum EndpointKinds {
    enum Public: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            // Here we can do things like assign a custom cache
            // policy for loading our publicly available data.
            // In this example we're telling URLSession not to
            // use any locally cached data for these requests:
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
        
    }
    
    enum Private: EndpointKind {
        
        static func prepare(_ request: inout URLRequest,
                            with token: AccessToken) {
            // For our private endpoints, we'll require an
            // access token to be passed, which we then use to
            // assign an Authorization header to each request:
            request.addValue("Bearer \(token.rawValue)",
                             forHTTPHeaderField: "Authorization"
            )
        }
    }
}

protocol EndpointKind {
    associatedtype RequestData
    static func prepare(_ request: inout URLRequest,
                        with data: RequestData)
    
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
