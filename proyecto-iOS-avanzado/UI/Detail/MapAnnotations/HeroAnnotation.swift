//
//  HeroAnnotation.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 26/10/23.
//

import UIKit
import MapKit

class HeroAnnotation: NSObject, MKAnnotation {
    var title: String?
    var info: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String? = nil, info: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info
        self.coordinate = coordinate
    }
}
