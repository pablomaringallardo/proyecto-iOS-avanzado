//
//  HeroDAO+CoreDataProperties.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 25/10/23.
//
//

import Foundation
import CoreData

@objc(HeroDAO)
public class HeroDAO: NSManagedObject {
    
}

extension HeroDAO {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeroDAO> {
        return NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
    }
    
    @NSManaged public var favorite: Bool
    @NSManaged public var heroDescription: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    
    func getHeroes() -> [HeroDAO] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<HeroDAO> = HeroDAO.fetchRequest()
        do {
            let heroes = try context.fetch(fetchRequest)
            return heroes
        } catch {
            return []
        }
    }
    
}

extension HeroDAO : Identifiable {
    
}


