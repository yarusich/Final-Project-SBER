//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let userDefaultsService = UserDefaultsService()
    
    private lazy var defaultQueryTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 17.0
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var profileTextLabel: UILabel = {
        let l = UILabel()
        l.text = "Запрос для поиска по-умолчанию"
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 22.0)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var changeProfileButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("Сменить запрос", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .systemOrange
        btm.alpha = 0.75
        btm.layer.cornerRadius = 20.0
        btm.addTarget(self, action: #selector(changeQueryButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var deleteDataFromUserDefaultsButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("Очистить запрос", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.alpha = 0.75
        btm.backgroundColor = .systemRed
        btm.layer.cornerRadius = 20.0
        btm.addTarget(self, action: #selector(deleteDataFromUserDefaultsButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        setView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil  {
        view.endEditing(true)
        }
    }
    
    private func setView() {
        view.addSubview(profileTextLabel)
        view.addSubview(changeProfileButton)
        view.addSubview(defaultQueryTextField)
        view.addSubview(deleteDataFromUserDefaultsButton)
        
        defaultQueryTextField.placeholder = setQuery()
        
        NSLayoutConstraint.activate([
            
            profileTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            
            defaultQueryTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultQueryTextField.topAnchor.constraint(equalTo: profileTextLabel.bottomAnchor, constant: 20.0),
            defaultQueryTextField.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.9),
                        
            changeProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeProfileButton.widthAnchor.constraint(equalToConstant: 150.0),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 40.0),
            changeProfileButton.topAnchor.constraint(equalTo: defaultQueryTextField.bottomAnchor, constant: 40.0),
            
            deleteDataFromUserDefaultsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteDataFromUserDefaultsButton.widthAnchor.constraint(equalToConstant: 150.0),
            deleteDataFromUserDefaultsButton.heightAnchor.constraint(equalToConstant: 40.0),
            deleteDataFromUserDefaultsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25.0),
        
        ])
    }
    
    @objc private func changeQueryButtonTapped() {
        guard let text = defaultQueryTextField.text else { return }
        
        userDefaultsService.addCurrentQuery(query: text)

        defaultQueryTextField.text = ""
        defaultQueryTextField.placeholder = userDefaultsService.getCurrentQuery()
    
        view.endEditing(true)
    }
    
    @objc private func deleteDataFromUserDefaultsButtonTapped() {
        userDefaultsService.clearCurrentQuery()
    }
    
    private func setQuery() -> String {
        let text = userDefaultsService.getCurrentQuery()
        if text == "" {
            return "Запрос по-умолчанию"
        } else {
            return text
        }
    }
}
