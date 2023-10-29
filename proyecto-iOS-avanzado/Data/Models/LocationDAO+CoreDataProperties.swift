//
//  LocationDAO+CoreDataProperties.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 27/10/23.
//
//

import Foundation
import CoreData

@objc(LocationDAO)
public class LocationDAO: NSManagedObject {

}

extension LocationDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationDAO> {
        return NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}

extension LocationDAO : Identifiable {

}
