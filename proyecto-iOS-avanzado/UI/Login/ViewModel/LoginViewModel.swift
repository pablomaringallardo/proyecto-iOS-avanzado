//
//  LoginViewModel.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 18/10/23.
//

import UIKit

class LoginViewModel: LoginViewControllerDelegate {
    
//    MARK: - Dependencies -
    private let networkManager: NetworkManagerProtocol
    private let secureData: SecureDataManagerProtocol
    
//    MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?
    
//    MARK: - Initializers -
    init(
        networkManager: NetworkManagerProtocol,
        secureData: SecureDataManagerProtocol
    ) {
        self.networkManager = networkManager
        self.secureData = secureData
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginResponse),
            name: NotificationCenter.loginNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
//    MARK: - Public functions -
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un email válido."))
                return
            }
            
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Contraseña incorrecta."))
                return
            }
            
            self.doLoginWith(
                email: email ?? "",
                password: password ?? ""
            )
        }
    }
    
    @objc func onLoginResponse(_ notification: Notification) {
        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
            !token.isEmpty else {
            return
        }
        
        secureData.save(token: token)
        viewState?(.loading(false))
        DispatchQueue.main.async {
            self.viewState?(.navigateToNext)
            
        }
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false)
    }
    
    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    
    private func doLoginWith(email: String, password: String) {
        networkManager.login(email: email, password: password)
    }
}
