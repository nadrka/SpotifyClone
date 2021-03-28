//
//  AuthService.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 23/03/2021.
//

import Foundation
import Combine

class AuthService {
    let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func getToken(code: String) -> AnyPublisher<AuthResponse, ApiError> {
        let endpoint = API.getToken(code: code)
        
        return client.call(type: AuthResponse.self, endpoint: endpoint)
    }
    
    func getToken(refreshToken: String) -> AnyPublisher<AuthResponse, ApiError>{
        let endpoint = API.getToken(refreshToken: refreshToken)
        
        return client.call(type: AuthResponse.self, endpoint: endpoint)
    }
    
}
