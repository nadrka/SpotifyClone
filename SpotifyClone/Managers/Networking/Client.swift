//
//  Client.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import Foundation

enum ApiError: Error {
    case cannotDecodeOutput
    case cannotEncodeInput
    case noData
    case invalidPath
    case other(error: Error)
}

class Client {
    
    func call<O: Decodable>(type: O.Type, endpoint: Endpoint, completion: @escaping (Result<O, ApiError>) -> ()) {
        let urlSession = URLSession(configuration: .default)
        
        guard let request = createRequest(for: endpoint) else {
            completion(.failure(.invalidPath))
            return
        }
        
        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.other(error: error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let output = try JSONDecoder().decode(type, from: data)
                completion(.success(output))
            } catch let jsonError {
                print(jsonError)
                completion(.failure(.cannotDecodeOutput))
            }
        }
        
        dataTask.resume()
        
    }
    
    func call<I: Codable, O: Decodable>(type: O.Type, input: I, endpoint: Endpoint, completion: @escaping (Result<O, ApiError>) -> ()) {
        let urlSession = URLSession(configuration: .default)
        
        guard var request = createRequest(for: endpoint) else {
            completion(.failure(.invalidPath))
            return
        }
        
        guard let body = try? JSONEncoder().encode(input) else {
            completion(.failure(.cannotEncodeInput))
            return
        }
        
        request.httpBody = body
        
        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.other(error: error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let output = try JSONDecoder().decode(type, from: data)
                completion(.success(output))
            } catch let jsonError {
                print(jsonError)
                completion(.failure(.cannotDecodeOutput))
            }
        }
        
        dataTask.resume()
        
    }
    
    private func createRequest(for endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.getURL(with: "") else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        return nil
    }
    
    
}
