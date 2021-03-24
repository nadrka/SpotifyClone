//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 15/03/2021.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    var onSignInTap: (() -> ())?
    
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
        onSignInTap?()
    }
    
}
