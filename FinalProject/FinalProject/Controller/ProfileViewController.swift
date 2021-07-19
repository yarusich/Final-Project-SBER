//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var profileTextLabel: UILabel = {
        let l = UILabel()
        l.text = "Пользователь"
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 22.0)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var changeProfileButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("Сменить профиль", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .red
        btm.layer.cornerRadius = 20.0
        btm.addTarget(self, action: #selector(changeProfileButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        setView()
    }
    
    private func setView() {
        view.addSubview(profileTextLabel)
        view.addSubview(changeProfileButton)
        
        NSLayoutConstraint.activate([
            profileTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            
            changeProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changeProfileButton.widthAnchor.constraint(equalToConstant: 200.0),
            changeProfileButton.heightAnchor.constraint(equalToConstant: 40.0),
            changeProfileButton.topAnchor.constraint(equalTo: profileTextLabel.bottomAnchor, constant: 40.0)
        
        ])
    }
    
    @objc private func changeProfileButtonTapped() {
        navigationController?.pushViewController(AuthorizationViewController(), animated: true)
    }
    
}
