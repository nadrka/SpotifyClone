//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 15/03/2021.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(signInButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(20)
            make.height.equalTo(Style.Sizes.buttonHeight)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spotify"
        self.view.backgroundColor = .systemGreen
    }
    
    
    @objc private func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            self?.handleSignIn(with: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(with success: Bool) {
        guard success else {
            assert(success, "Something went wrong when sign in")
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        
        present(mainAppTabBarVC, animated: true)
    }
}
