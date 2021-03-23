//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 15/03/2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        enum Scopes: String, CaseIterable {
            case userReadPrivate = "user-read-private"
            case playlistModifyPrivate = "playlist-modify-private"
            case playlistModifyPublic = "playlist-modify-public"
            case playlistReadPublic = "playlist-read-private"
            case userFollowRead = "user-follow-read"
            case userLibraryModify = "user-library-modify"
            case userLibraryRead = "user-library-read"
            case userReadEmail = "user-read-email"
            
        }
        static let clientID = "1bacab2ad47843518461caa89cd45d62"
        static let clientSecret = "38bbe290119c4c81bcc9fdb04f8a521a"
        static let redirectURI = "https://iosacademy.io"
        static let scopes = Scopes.allCases.map { $0.rawValue }.joined(separator: "%20")
        static let token = clientID + ":" + clientSecret
        
        static var basicToken64: String {
            let data = token.data(using: .utf8)
            return data?.base64EncodedString() ?? ""
        }
    }
    
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
        let authService = AuthService(client: AuthClient())
        
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
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = refreshToken else {
            return
        }
        
        let authService = AuthService(client: AuthClient())
        
        authService.getToken(refreshToken: refreshToken) { [weak self] result in
            switch result {
            case .success(let result):
                print("Successfully refreshed")
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
