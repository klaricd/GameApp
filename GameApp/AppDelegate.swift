//
//  AppDelegate.swift
//  GameApp
//
//  Created by David Klaric on 02.02.2023..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let islaunchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let navigationController: UINavigationController
        
        if islaunchedBefore {
            let gamesViewController = storyboard.instantiateViewController(withIdentifier: "gamesVC") as! GamesTableViewController
            navigationController = UINavigationController(rootViewController: gamesViewController)
        } else {
            let genresViewController = storyboard.instantiateViewController(withIdentifier: "genresVC") as! GenresTableViewController
            navigationController = UINavigationController(rootViewController: genresViewController)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        self.window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
                
        return true
    }
}

