//
//  Endpoint.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import Foundation

typealias Parameters = [String: Any]

struct Endpoint {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    let path: String
    let method: HttpMethod
    let queryParameters: Parameters?
    
    func getURL(with baseURL: String) -> URL? {
        return URL(string: baseURL + path)
    }
}
