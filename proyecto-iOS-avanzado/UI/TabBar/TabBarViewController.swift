//
//  TabBarViewController.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 27/10/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
//    MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewRespectsSystemMinimumLayoutMargins = false
        setupTabs()
        setupLayout()
    }
    
//    MARK: - Private functions -
    private func setupTabs() {
        let listHeroesViewController = ListHeroesTableViewController()
        listHeroesViewController.viewModel = ListHeroesViewModel(
            networkManager: NetworkManager(),
            secureDataManager: SecureDataManager()
        )
        
        let navigationController1 = UINavigationController(rootViewController: listHeroesViewController)
        
        let mapViewController = MapViewController()
        mapViewController.viewModel = MapViewModel(
            networkManager: NetworkManager(),
            secureDataManager: SecureDataManager()
        )
        
        let navigationController2 = UINavigationController(rootViewController: mapViewController)
        
        let tabImageHome = UIImage(systemName: "house.fill")!
        let tabImageMap = UIImage(systemName: "mappin.circle.fill")
        
        navigationController1.tabBarItem = UITabBarItem(
            title: "Heroes",
            image: tabImageHome,
            tag: 0
        )
        
        navigationController2.tabBarItem = UITabBarItem(
            title: "Mapa",
            image: tabImageMap,
            tag: 1
        )
        
        
        

        viewControllers = [navigationController1, navigationController2]
    }

    private func setupLayout() {
        tabBar.backgroundColor = .systemBackground
    }

}
