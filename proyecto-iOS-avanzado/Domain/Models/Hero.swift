//
//  Hero.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 24/10/23.
//

import Foundation


typealias Heroes = [Hero]

struct Hero: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo
        case description
        case isFavorite = "favorite"
    }
    
    let id: String?
    let name: String?
    let photo: String?
    let description: String?
    let isFavorite: Bool?
}
