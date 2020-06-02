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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let todayViewController = InitialViewController()
        let resultsViewController = ResultsViewController()
        resultsViewController.title = "Histórico"
        let nav = RegularNavigationController()
        nav.viewControllers = [resultsViewController, todayViewController]
        nav.title = "Progresso"
        nav.tabBarItem = UITabBarItem(title: "Progresso",
                                      image: UIImage(named: "NinaTab2"),
                                      selectedImage: UIImage(named: "NinaTab"))
        
        let dynamic = DynamicViewController(urlString: Secrets.screenURL)
        dynamic.title = "Informações"
        dynamic.tabBarItem = UITabBarItem(title: "Informações",
                                          image: UIImage(systemName: "bell"),
                                          selectedImage: UIImage(systemName: "bell.fill"))
        let nav2 = RegularNavigationController()
        nav2.viewControllers = [dynamic]
        
        let tab = UITabBarController()
        tab.view.tintColor = Color.primaryButton
        tab.viewControllers = [nav, nav2]
        
        
        window.rootViewController = tab
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

