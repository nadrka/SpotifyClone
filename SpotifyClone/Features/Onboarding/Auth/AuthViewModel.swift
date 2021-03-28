//
//  AuthViewModel.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 24/03/2021.
//

import Foundation
import Combine

class AuthViewModel {
    
    public var completionHandler: ((Bool) -> ())?
    private var cancellables = Set<AnyCancellable>()
    
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
        
        authManager.exchangeCodeForToken(code: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] success in
                self?.completionHandler?(success)
            }).store(in: &cancellables)
    }
    
}
