//
//  SettingsViewModel.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import Foundation

class SettingsViewModel {
    var sections: [Section] = [
        Section(title: "Profile", options: [
            .viewProfile,
        ]),
        Section(title: "Account", options: [
            .signOut
        ]),
    ]
}

extension SettingsViewModel {
    struct Section: Hashable {
        let title: String
        let options: [Option]
    }
    
    enum Option: String, CaseIterable {
        case viewProfile = "View Your Profile"
        case signOut = "Sign out"
    }
}
