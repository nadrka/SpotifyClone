//
//  SceneDelegate.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainFlow: MainFlow!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let rootNavigationContoller = UINavigationController()
        rootNavigationContoller.navigationBar.prefersLargeTitles = true
        
        mainFlow = MainFlow(rootViewController: rootNavigationContoller)
        window.rootViewController = rootNavigationContoller
        
        window.makeKeyAndVisible()
        
        mainFlow.start()
        
        self.window = window
        
    }
    
}

