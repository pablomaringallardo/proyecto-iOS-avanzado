//
//  DetailViewModel.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 26/10/23.
//

import Foundation

class DetailViewModel: DetailViewControllerDelegate {
    
    private let networkManager: NetworkManagerProtocol
    private let secureDataManager: SecureDataManagerProtocol
    
    var viewState: ((DetailViewState) -> Void)?
    private var hero: Hero
    private var heroLocations: [HeroLocation] = []
    
    init(
        hero: Hero,
        networkManager: NetworkManagerProtocol,
        secureDataManager: SecureDataManagerProtocol
    ) {
        self.hero = hero
        self.networkManager = networkManager
        self.secureDataManager = secureDataManager
    }
    
    func onViewAppear() {
        DispatchQueue.global().async {
            guard let token = self.secureDataManager.getToken() else {
                return
            }
            
            self.networkManager.getLocations(
                heroId: self.hero.id,
                token: token) { [weak self] heroLocations in
                    self?.heroLocations = heroLocations
                    self?.viewState?(.update(hero: self?.hero, locations: heroLocations))
                }
        }
    }
}
