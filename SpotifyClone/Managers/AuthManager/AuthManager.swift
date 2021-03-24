//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 15/03/2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    let authService = AuthService(client: AuthClient())
    private var refreshingToken = false
    
    private init() {}
    
    public var signInUrl: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string =
            "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=true"
        print(string)
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        !UserDefaultsManager.accessToken.emptyOrNil
    }
    
    private var accessToken: String? {
        UserDefaultsManager.accessToken
    }
    
    private var refreshToken: String? {
        UserDefaultsManager.refreshToken
    }
    
    private var tokenExpirationDate: Date? {
        UserDefaultsManager.expirationDate
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        authService.getToken(code: code) { [weak self] result in
            switch result {
            case .success(let result):
                self?.cacheResult(result: result)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private var onRefreshBlocks = [(String) -> Void]()
    
    public func withValidToken(completion: @escaping (_ token: String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        }
        else if let token = accessToken {
            completion(token)
        }
    }
    
    
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = refreshToken else {
            return
        }
        
        refreshingToken = true
        
        authService.getToken(refreshToken: refreshToken) { [weak self] result in
            self?.refreshingToken = false
            switch result {
            case .success(let result):
                print("Successfully refreshed")
                self?.onRefreshBlocks.forEach { $0(result.accessToken)}
                self?.onRefreshBlocks.removeAll()
                self?.cacheResult(result: result)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func cacheResult(result: AuthResponse) {
        UserDefaultsManager.accessToken = result.accessToken
        if let refreshToken = result.refreshToken {
            UserDefaultsManager.refreshToken = refreshToken
        }
        
        let timeInterval = TimeInterval(result.expiresIn)
        let expirationDate = Date().addingTimeInterval(timeInterval)
        UserDefaultsManager.expirationDate = expirationDate
    }
}
