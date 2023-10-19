//
//  NetworkManager.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 19/10/23.
//

import Foundation

protocol NetworkManagerProtocol {
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void)
}

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

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    static private let baseUrl = "https://dragonball.keepcoding.education/"
    
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        
        guard let url = URL(string: "\(NetworkManager.baseUrl)\(Endpoint.login.rawValue)") else {
            completion(nil, NetworkError.malformedUrl)
            return
        }
        
        let loginString = "\(email):\(password)"
        let loginData: Data = loginString.data(using: .utf8)!
        let base64 = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completion(nil, NetworkError.statusCode(code: statusCode))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(token, nil)
        }
        task.resume()
    }
}
