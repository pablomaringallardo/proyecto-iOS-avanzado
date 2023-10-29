//
//  ListHeroesViewModel.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 20/10/23.
//

import Foundation
import CoreData

// MARK: - CLASE -
class ListHeroesViewModel: ListHeroesTableViewControllerDelegate {
    
    //    MARK: - Dependencies -
    private let networkManager: NetworkManager
    private let secureDataManager: SecureDataManagerProtocol
    
    //    MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int {
        heroes.count
    }
    var heroes: Heroes = []
    
    //    MARK: - Initializers -
    init(
        networkManager: NetworkManager,
        secureDataManager: SecureDataManagerProtocol
    ) {
        self.networkManager = networkManager
        self.secureDataManager = secureDataManager
    }
    
//    MARK: - Public functions -
    func onViewAppear() {
        DispatchQueue.global().async {
            guard let token = self.secureDataManager.getToken() else { return }
            
            self.fetchHeroesApiOrCoreData(token: token)
        }
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            heroes[index]
        } else {
            nil
        }
    }
    
    func fetchHeroesApiOrCoreData(token: String) {
        let heroes = Global.shared.getHeroesCoreData(context: Global.shared.context)
            if heroes.count > 0 {
                heroes.forEach { hero in
                    self.heroes.append(Hero(
                        id: hero.id,
                        name: hero.name ?? "",
                        photo: hero.photo,
                        description: hero.heroDescription,
                        isFavorite: hero.favorite)
                    )
                }
                print("COREDATA")
            } else {
                self.networkManager.getHeroes(name: nil,
                                              token: token) { heroes in
                    self.heroes = heroes
                    
                    
                    
                    self.heroes.forEach { hero in
                        let newHero = HeroDAO(context: Global.shared.context)
                        newHero.id = hero.id
                        newHero.name = hero.name
                        newHero.heroDescription = hero.description
                        newHero.photo = hero.photo
                        newHero.favorite = hero.isFavorite ?? false
                    }
                    print("API")
                    Global.shared.saveCoreData()
                    
                    self.viewState?(.updateData)
                }
            }
    }
    
    func logOut() {
        SecureDataManager().deleteToken()
    }
    
    func deleteCoreData() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = HeroDAO.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            self.heroes = []
            
        } catch {
            print("Error al borrar los datos de Core Data")
        }
    }
    
    func filterHeroes(with searchText: String) {
        
    }
    
    func clearSearch() {
        
    }
}
