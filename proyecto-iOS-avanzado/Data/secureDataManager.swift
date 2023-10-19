//
//  secureDataManager.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 19/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataManagerProtocol {
    func save(token: String)
    func getToken() -> String?
}

final class SecureDataManager: SecureDataManagerProtocol {
    private let keychain = KeychainSwift()
    
    private enum Key: String {
        case token = "key_token"
    }
    
    func save(token: String) {
        keychain.set(token, forKey: Key.token.rawValue)
    }
    
    func getToken() -> String? {
        keychain.get(Key.token.rawValue)
    }
}
