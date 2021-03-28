//
//  TabViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import UIKit

enum TabBarTag: Int {
    case home = 1
    case search = 2
    case library = 3
}

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViewControllers()
    }
    
    private func prepareViewControllers() {
        viewControllers = [
            createNavController(for: HomeViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house"), tag: TabBarTag.home.rawValue),
            createNavController(for: SearchViewController(), title: NSLocalizedString("Search", comment: ""), image: UIImage(systemName: "magnifyingglass"), tag: TabBarTag.search.rawValue),
            createNavController(for: LibraryViewController(), title: NSLocalizedString("Library", comment: ""), image: UIImage(systemName: "person"), tag: TabBarTag.library.rawValue)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage?,
                                         tag: Int) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.tag = tag
        navController.navigationBar.tintColor = .label
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}


