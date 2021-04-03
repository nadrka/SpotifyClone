//
//  Endpoint.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import Foundation

typealias Parameters = [String: Any]
typealias Headers = [String: String]
typealias Body = [String: String]

struct Endpoint {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    let method: HttpMethod
    let path: String
    let queryParameters: Parameters?
    let headers: Headers?
    let body: Body?
    let authorizationNeeded: Bool
    
    init(method: HttpMethod,
         path: String,
         queryParameters: Parameters? = nil,
         headers: Headers? = nil,
         body: Body? = nil,
         authorizationNeeded: Bool
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
        self.authorizationNeeded = authorizationNeeded
    }
    
    
    func url(with baseURL: String) -> URL? {
        let string = baseURL + path
        
        guard var urlComps = URLComponents(string: string) else {
            return nil
        }
        
        guard let parameters = queryParameters else {
            return urlComps.url
        }
        
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
        
        urlComps.queryItems = queryItems
        
        return urlComps.url
        
    }
    
}
