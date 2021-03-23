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
        showMainTabScreen()
    }
    
    private func showWelcomeScreen() {
        let vc = WelcomeViewController()
    
        rootViewController.viewControllers = [vc]
    }
    
    private func showMainTabScreen() {
        let vc = TabBarViewController()
        rootViewController.viewControllers = [vc]
    }
    
}

