import Foundation

enum ApiError: Error {
    case cannotDecodeOutput
    case cannotEncodeInput
    case noData
    case invalidPath
    case other(error: Error)
}

protocol Client {
    var baseUrl: String { get }
    func call<O: Decodable>(type: O.Type,
                            endpoint: Endpoint,
                            completion: @escaping (_ result: Result<O, ApiError>) -> Void)
}

extension Client {

    public func call<O: Decodable>(type: O.Type,
                            endpoint: Endpoint,
                            completion: @escaping (_ result: Result<O, ApiError>) -> Void ){
        
        guard let request = self.createUrlRequest(for: endpoint) else {
            completion(.failure(ApiError.invalidPath))
            return
        }

        let session = URLSession(configuration: .default)

        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.other(error: error)))
                return
            }

            guard let data = data else {
                completion(.failure(ApiError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let output = try decoder.decode(O.self, from: data)
                completion(.success(output))
            } catch let jsonError {
                print(jsonError)
                completion(.failure(ApiError.cannotDecodeOutput))

            }
        }

        dataTask.resume()
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
