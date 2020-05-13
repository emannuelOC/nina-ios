//
//  SceneDelegate.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let todayViewController = InitialViewController()
        let resultsViewController = ResultsViewController()
        let nav = RegularNavigationController()
        nav.viewControllers = [resultsViewController, todayViewController]
        
        
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

