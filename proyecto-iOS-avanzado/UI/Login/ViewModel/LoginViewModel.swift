//
//  LoginViewModel.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 18/10/23.
//

import Foundation

class LoginViewModel: LoginViewControllerDelegate {
    
    // MARK: - Dependencies -
    private let networkManager: NetworkManagerProtocol
    private let secureData: SecureDataManagerProtocol
    
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?
    
    // MARK: - Initializers -
    init(networkManager: NetworkManagerProtocol, secureData: SecureDataManagerProtocol) {
        self.networkManager = networkManager
        self.secureData = secureData
    }
    
    
    // MARK: - Public functions -
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        guard let email, !email.isEmpty else {
            return
        }
        print("Email: \(email)")
        guard let password, !password.isEmpty else {
            return
        }
        print("Password: \(password)")
        networkManager.login(email: email, password: password) { token, error in
            if let token {
                self.secureData.save(token: token)
                print("Login correcto: \(token)")
            } else {
                print("Login incorrecto")
            }
        }
    }
}
