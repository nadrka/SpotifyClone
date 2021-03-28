//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    let userProfileService = UserProfileService()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Profile"
        
        
        userProfileService.getCurrentUserProfile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] profile in
                self?.updateUI(with: profile)
            })
            .store(in: &cancellables)
    }
    
    
    
    private func updateUI(with profile: Profile) {
        print(profile)
        failedToGetProfile()
    }
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}
