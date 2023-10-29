//
//  Global.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 27/10/23.
//

import Foundation
import CoreData

class Global {
    
//    MARK: - Dependecies -
    static let shared = Global()
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
//    MARK: - Public functions -
    func getHeroesCoreData(context: NSManagedObjectContext) -> [HeroDAO] {
        let fetchRequest: NSFetchRequest<HeroDAO> = HeroDAO.fetchRequest()
        do {
            let heroes = try context.fetch(fetchRequest)
            return heroes
        } catch {
            return []
        }
    }
    
    func getLocationsCoreData(context: NSManagedObjectContext) -> [LocationDAO] {
        let fetchRequest: NSFetchRequest<LocationDAO> = LocationDAO.fetchRequest()
        do {
            let locations = try context.fetch(fetchRequest)
            return locations
        } catch {
            return []
        }
    }
    
    func saveCoreData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
