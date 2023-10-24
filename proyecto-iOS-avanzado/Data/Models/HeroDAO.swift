//
//  HeroDAO.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 24/10/23.
//

import Foundation
import CoreData

@objc(HeroDao)
class HeroDAO: NSManagedObject {
    
    static let entityName = "HeroDAO"
    
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var photo: String?
    @NSManaged var heroDescription: String?
    @NSManaged var favorite: Bool
}
