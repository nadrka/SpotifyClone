//
//  AuthManager+Constants.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 24/03/2021.
//

import Foundation

extension AuthManager {
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
}
