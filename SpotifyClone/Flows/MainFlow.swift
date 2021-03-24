import UIKit

protocol Flow {
    func start()
}

final class MainFlow: Flow {
    private var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        if AuthManager.shared.isSignedIn {
            showMainTabBarScreen()
        } else {
            showWelcomeScreen()
        }
    }
    
    private func showWelcomeScreen() {
        let vc = WelcomeViewController()
    
        vc.onSignInTap = { [weak self] in
            self?.showAuthScreen()
        }
        
        rootViewController.viewControllers = [vc]
    }
    
    private func showAuthScreen() {
        let vm = AuthViewModel()
        let vc = AuthViewController(viewModel: vm)
        vm.completionHandler = { [weak self] success in
            self?.handleSignIn(with: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        rootViewController.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(with success: Bool) {
        guard success else {
            assert(success, "Something went wrong when sign in")
            return
        }
        rootViewController.popViewController(animated: false)
        showMainTabBarScreen()
    }
    
    private func showMainTabBarScreen() {
        let vc = TabBarViewController()
        
        vc.modalPresentationStyle = .fullScreen
        
        vc.navigationItem.largeTitleDisplayMode = .never
                
        rootViewController.present(vc, animated: false)
    }
    
    
}

