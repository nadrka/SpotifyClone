//
//  Endpoint.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import Foundation

struct Endpoint {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    let path: String
    let method: HttpMethod
    let queryParameters: [String: Any]?
    
    func getURL(with baseURL: String) -> URL? {
        return URL(string: baseURL + path)
    }
}
