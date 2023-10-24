//
//  LoginViewController.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 18/10/23.
//

import UIKit

// MARK: - PROTOCOL -
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    func onLoginPressed(email: String?, password: String?)
}

// MARK: - STATE -
enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail (_ error: String?)
    case showErrorPassword (_ error: String?)
    case navigateToNext
}

// MARK: - CLASS -
class LoginViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var imageLoginView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailMessageError: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordMessageError: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Actions -
    @IBAction func buttonLoginAction(_ sender: Any) {
        viewModel?.onLoginPressed(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
    
    // MARK: - Public Properties -
    var viewModel: LoginViewControllerDelegate?
    
    private enum FieldType: Int {
        case email = 0
        case password
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        emailTextField.text = "pablomaringallardo17@gmail.com"
        passwordTextField.text = "123456"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.alpha = 0
        passwordTextField.alpha = 0
        buttonLogin.alpha = 0
        
        imageLoginView.center.y = view.bounds.height / 2
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0) {
            self.imageLoginView.center.y = 248
        }
        
        
        
        UIView.animate(withDuration: 1) {
            self.emailTextField.alpha = 1
            self.passwordTextField.alpha = 1
            self.buttonLogin.alpha = 1
        }
    }
    
    // MARK: - Private functions -
    private func initViews() {
        emailTextField.delegate = self
        emailTextField.tag = FieldType.email.rawValue
        passwordTextField.delegate = self
        passwordTextField.tag = FieldType.password.rawValue
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)
            )
        )
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    
                case .showErrorEmail(let error):
                    self?.emailMessageError.text = error
                    self?.emailMessageError.isHidden = (error == nil || error?.isEmpty == true)
                    
                case .showErrorPassword(let error):
                    self?.passwordMessageError.text = error
                    self?.passwordMessageError.isHidden = (error == nil || error?.isEmpty == true)
                    
                case .navigateToNext:
                    self?.navigationController?.setViewControllers([ListHeroesTableViewController()], animated: true)
                }
            }
        }
    }
}
    
    // MARK: - EXTENSION -
    extension LoginViewController: UITextFieldDelegate {
        func textFieldDidEndEditing(_ textField: UITextField) {
            switch FieldType(rawValue: textField.tag) {
            case .email:
                emailMessageError.isHidden = true
                
            case .password:
                passwordMessageError.isHidden = true
                
            default: break
            }
        }
    }

