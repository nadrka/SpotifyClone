//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import UIKit

class ProfileViewController: UIViewController {
    let userProfileService = UserProfileService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Profile"
        
        userProfileService.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.updateUI(with: profile)
                case .failure(let error):
                    print("ProfileViewController: \(error)")
                }
            }
        }
    }
    
    private func updateUI(with profile: Profile) {
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
