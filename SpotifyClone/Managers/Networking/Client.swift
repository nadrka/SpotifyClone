//
//  Client.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import Foundation
import Combine

enum ApiError: Error {
    case cannotDecodeOutput
    case cannotEncodeInput
    case noData
    case invalidPath
    case other(error: Error)
}

class Client {
    
    func call2<O: Decodable>(type: O.Type, endpoint: Endpoint) -> AnyPublisher<O, ApiError> {
        guard let request = createRequest(for: endpoint) else {
            return Fail(error: ApiError.invalidPath).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                ApiError.other(error: error)
            }
            .map(\.data)
            .decode(type: O.self, decoder: JSONDecoder())
            .mapError { _ in
                ApiError.cannotDecodeOutput
            }
            .eraseToAnyPublisher()
    }
    
    func call<O: Decodable>(type: O.Type, endpoint: Endpoint) -> Future<O, ApiError> {
        let urlSession = URLSession(configuration: .default)
        
        guard let request = createRequest(for: endpoint) else {
            return Future { promise in
                promise(.failure(.invalidPath))
            }
        }
        
        return Future { promise in
            let dataTask = urlSession.dataTask(with: request) { data, _, error in
                if let error = error {
                    promise(.failure(.other(error: error)))
                    return
                }
                guard let data = data else {
                    promise(.failure(.noData))
                    return
                }
                
                do {
                    let output = try JSONDecoder().decode(type, from: data)
                    promise(.success(output))
                } catch let jsonError {
                    print(jsonError)
                    promise(.failure(.other(error: jsonError)))
                }
            }
            
            dataTask.resume()
        }
    }
    
    func call<I: Codable, O: Decodable>(type: O.Type, input: I, endpoint: Endpoint) -> Future<O, ApiError> {
        let urlSession = URLSession(configuration: .default)
        
        guard var request = createRequest(for: endpoint) else {
            return Future { promise in
                promise(.failure(.invalidPath))
            }
        }
        
        guard let body = try? JSONEncoder().encode(input) else {
            return Future { promise in
                promise(.failure(.cannotEncodeInput))
            }
        }
        
        request.httpBody = body
        
        return Future { promise in
            let dataTask = urlSession.dataTask(with: request) { data, _, error in
                if let error = error {
                    promise(.failure(.other(error: error)))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(.noData))
                    return
                }
                
                do {
                    let output = try JSONDecoder().decode(type, from: data)
                    promise(.success(output))
                } catch let jsonError {
                    print(jsonError)
                    promise(.failure(.other(error: jsonError)))
                }
            }
            
            dataTask.resume()
        }
    }
    
    private func createRequest(for endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.getURL(with: "") else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        return urlRequest
    }
    
}
