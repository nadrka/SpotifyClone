//
//  AuthService.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 23/03/2021.
//

import Foundation

class AuthService {
    let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func getToken(code: String, completion: @escaping (Result<AuthResponse, ApiError>) -> Void) {
        let endpoint = API.getToken(code: code)
        
        client.call(type: AuthResponse.self, endpoint: endpoint, completion: completion)
    }
    
    func getToken(refreshToken: String, completion: @escaping (Result<AuthResponse, ApiError>) -> Void) {
        let endpoint = API.getToken(refreshToken: refreshToken)
        
        client.call(type: AuthResponse.self, endpoint: endpoint, completion: completion)
    }
    
}
