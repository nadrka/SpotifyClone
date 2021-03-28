//
//  UserProfileService.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import Foundation

class UserProfileService {
    let client: Client
    
    init(client: Client = MainClient()) {
        self.client = client
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<Profile, ApiError>) -> Void) {
        let endpoint = API.getCurrentUserProfile()
        
        client.call(type: Profile.self, endpoint: endpoint, completion: completion)
    }
   
}
