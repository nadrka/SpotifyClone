//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 21/03/2021.
//

import UIKit
import WebKit
import SnapKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    let viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        
        webView.navigationDelegate = self
        guard let url = viewModel.url else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        viewModel.exchangeCodeForToken(url: url)
    }
    
    
}
