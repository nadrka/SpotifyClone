//
//  AuthViewModel.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 24/03/2021.
//

import Foundation

class AuthViewModel {
    
    public var completionHandler: ((Bool) -> ())?
    
    let authManager = AuthManager.shared
    
    var url: URL? {
        authManager.signInUrl
    }
    
    public func exchangeCodeForToken(url: URL) {
        // Exchange the code for access token
        
        let component = URLComponents(string: url.absoluteString)
        
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        authManager.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.completionHandler?(success)
            }
        }
    }
    
}
