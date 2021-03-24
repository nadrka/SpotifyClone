//
//  AppDelegate.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var mainFlow: MainFlow!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootNavigationContoller = UINavigationController()
        rootNavigationContoller.navigationBar.prefersLargeTitles = true
        
        mainFlow = MainFlow(rootViewController: rootNavigationContoller)
        window?.rootViewController = rootNavigationContoller
        
        window?.makeKeyAndVisible()
        
        mainFlow.start()
  
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    
}

