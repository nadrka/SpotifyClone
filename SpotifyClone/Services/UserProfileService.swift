//
//  UserProfileService.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import Foundation
import Combine

class UserProfileService {
    let client: Client
    
    init(client: Client = MainClient()) {
        self.client = client
    }
    
    public func getCurrentUserProfile() -> AnyPublisher<Profile, ApiError> {
        let endpoint = API.getCurrentUserProfile()
        
        return client.call(type: Profile.self, endpoint: endpoint)
    }
   
}
