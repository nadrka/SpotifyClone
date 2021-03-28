//
//  AuthManager.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 15/03/2021.
//

import Foundation
import Combine

final class AuthManager {
    static let shared = AuthManager()
    let authService = AuthService(client: AuthClient())
    private var refreshingToken = false
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    public func exchangeCodeForToken(code: String) -> AnyPublisher<Bool, ApiError> {
        let subject = PassthroughSubject<Bool, ApiError>()
        
        authService.getToken(code: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] (authReponse: AuthResponse) in
                self?.cacheResult(result: authReponse)
                subject.send(true)
            }).store(in: &cancellables)
        
        return subject.eraseToAnyPublisher()
    }
    
    public func withValidToken() -> AnyPublisher<String, ApiError> {
        guard let refreshToken = refreshToken else {
            return Fail(error: ApiError.noToken)
                .eraseToAnyPublisher()
        }
        if shouldRefreshToken {
            return authService.getToken(refreshToken: refreshToken)
                .map(\.accessToken)
                .eraseToAnyPublisher()
        }
        else if let token = accessToken {
            return Just(token)
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()
        } else {
            fatalError("Nie powinno się wywalić")
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
