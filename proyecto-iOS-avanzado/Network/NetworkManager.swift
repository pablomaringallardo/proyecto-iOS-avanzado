//
//  NetworkManager.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 19/10/23.
//

import Foundation

// MARK: - Protocolo -
protocol NetworkManagerProtocol {
    func login(email: String, password: String)
}

// MARK: - Enums -
enum NetworkError: Error {
    case malformedUrl
    case noData
    case statusCode(code: Int?)
    case decodingFailed
}

enum HttpMethods: String {
    case post = "POST"
}

enum Endpoint: String {
    case login = "api/auth/login"
}


// MARK: - Clase -
class NetworkManager: NetworkManagerProtocol {
    
//    MARK: - Constants -
    
    static private let baseUrl = "https://dragonball.keepcoding.education/"
    
    
//    MARK: - NetworkManagerProtocol -
    
    func login(email: String, password: String) {
        guard let url = URL(string: "\(NetworkManager.baseUrl)\(Endpoint.login.rawValue)") else {
            return
        }
        
        guard let loginData = String(format: "%@:%@",
                                     email, password).data(using: .utf8)?.base64EncodedString() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
//                TODO: Enviar notificacion indicando el error
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
//                TODO: Enviar notificacion indicando response error
                return
            }
            
            guard let responseData = String(data: data, encoding: .utf8) else {
//                TODO: Enviar notificacion indicando response vacío
                return
            }
            
            NotificationCenter.default.post(
                name: NotificationCenter.loginNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey: responseData]
            )
        }.resume()
    }
}

extension NotificationCenter {
    static let loginNotification = Notification.Name("NOTIFICATION_LOGIN")
    static let tokenKey = "TOKEN"
}
