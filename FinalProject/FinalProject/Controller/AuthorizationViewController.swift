//
//  AuthorizationViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit

final class AuthorizationViewController: UIViewController {
//    MARK: в этом vc будем создавать таб бар контроллер
    
    private let authorizationModel = AuthorizationModel()
    
    private lazy var authorizationTextLabel: UILabel = {
        let l = UILabel()
        l.text = "Введите имя пользователя:"
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 22.0)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var authorizationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "имя пользователя"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 17.0
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var signInButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("Sign in", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        btm.backgroundColor = .red
        btm.layer.cornerRadius = 22.0
        btm.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var signUpButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.backgroundColor = .red
        btm.setTitle("Sign up", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        btm.layer.cornerRadius = 22.0
        btm.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Авторизация"
    }
    
    private func setupView() {
        view.addSubview(authorizationTextLabel)
        view.addSubview(authorizationTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            authorizationTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            authorizationTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            authorizationTextLabel.bottomAnchor.constraint(equalTo: authorizationTextField.topAnchor, constant: -25),
            
            
            authorizationTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authorizationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            authorizationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            authorizationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            signInButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 45),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            signUpButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
    }
    
    private func correctText(_ name: String?) -> String? {
        guard let name = authorizationTextField.text else { return nil }
        return name
    }
    
    @objc private func signInButtonTapped() {
        guard let name = correctText(authorizationTextField.text) else { return }
        if authorizationModel.checkUser(name) {
            authorizationTextLabel.text = "Пользователь не найден"
            authorizationTextLabel.textColor = .red
        } else {
            authorizationTextLabel.text = "Введите имя пользователя:"
            authorizationTextLabel.textColor = .black
            authorizationModel.addCurrentUser(name)
            navigationController?.pushViewController(MainViewController(networkService: NetworkService()), animated: true)
//            navigationController?.pushViewController(ProfileViewController(), animated: true)
        }

    }
    
    @objc private func signUpButtonTapped() {
        guard let name = correctText(authorizationTextField.text) else { return }
        if authorizationModel.checkUser(name) {
            authorizationModel.appendNewUser(name)
            authorizationTextLabel.text = "Пользователь добавлен"
            authorizationTextLabel.textColor = .black
        } else {
            authorizationTextLabel.text = "Такой пользователь уже есть"
            authorizationTextLabel.textColor = .red
        }
    }

    deinit {
        print("deinit AuthorizationViewController")
    }
}
