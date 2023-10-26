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
    func getHeroes(name: String?, token: String, completion: ((Heroes) -> Void)?)
    func getLocations(heroId: String?, token: String, completion: (([HeroLocation]) -> Void)?)
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
    case heroes = "api/heros/all"
    case heroLocation = "api/heros/locations"
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
    
    func getHeroes(name: String?, token: String, completion: ((Heroes) -> Void)?) {
        guard let url = URL(string: "\(NetworkManager.baseUrl)\(Endpoint.heroLocation.rawValue)") else {
            return
        }
        
        let jsonData: [String: Any] = ["name": name ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",
                            forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                completion?([])
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }
            
            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
                completion?([])
                return
            }
            
            completion?(heroes)
            
        }.resume()
    }
    
    func getLocations(heroId: String?, token: String, completion: (([HeroLocation]) -> Void)?) {
        guard let url = URL(string: "\(NetworkManager.baseUrl)\(Endpoint.heroes.rawValue)") else {
            return
        }
        
        let jsonData: [String: Any] = ["id": heroId ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",
                            forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                completion?([])
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }
            
            guard let locations = try? JSONDecoder().decode([HeroLocation].self, from: data) else {
                completion?([])
                return
            }
            
            print("API RESPONSE LOCATIONS: \(locations)")
            completion?(locations)
            
        }.resume()
    }
}

extension NotificationCenter {
    static let loginNotification = Notification.Name("NOTIFICATION_LOGIN")
    static let tokenKey = "TOKEN"
}
