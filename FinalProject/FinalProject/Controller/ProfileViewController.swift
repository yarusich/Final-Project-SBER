//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    var query = "Введите слово"
    
    private lazy var defaultQueryTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = query
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
        btm.backgroundColor = .red
        btm.layer.cornerRadius = 20.0
        btm.addTarget(self, action: #selector(changeQueryButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        setView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first as? UITouch {
        view.endEditing(true)
        }
    }
    
    private func setView() {
        view.addSubview(profileTextLabel)
        view.addSubview(changeProfileButton)
        view.addSubview(defaultQueryTextField)
        
        
        NSLayoutConstraint.activate([
            
            profileTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            
            defaultQueryTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultQueryTextField.topAnchor.constraint(equalTo: profileTextLabel.bottomAnchor, constant: 40.0),
            defaultQueryTextField.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 1),
                        
            changeProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeProfileButton.widthAnchor.constraint(equalToConstant: 200.0),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 40.0),
            changeProfileButton.topAnchor.constraint(equalTo: defaultQueryTextField.bottomAnchor, constant: 40.0),
        
        ])
    }
    
    @objc private func changeQueryButtonTapped() {
        guard let text = defaultQueryTextField.text else { return }
        query = text
        defaultQueryTextField.text = ""
        defaultQueryTextField.placeholder = text
        print(query)
        view.endEditing(true)
    }
    
}
