//
//  SceneDelegate.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 18/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let loginViewController = LoginViewController()
        loginViewController.viewModel = LoginViewModel(
            networkManager: NetworkManager(),
            secureData: SecureDataManager()
        )
        
        window?.rootViewController = SecureDataManager().getToken() == nil ? loginViewController : TabBarViewController()
        
        window?.makeKeyAndVisible()
//        self.window = window
    }
}

