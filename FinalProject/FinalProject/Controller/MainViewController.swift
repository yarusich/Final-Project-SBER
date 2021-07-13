//
//  MainViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        mainView.setupView()
        mainView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        MARK: Скрыли наш нав бар
        navigationController?.navigationBar.isHidden = true
    }
    
}

extension MainViewController: MainViewDelegate {
    
    func selected(at index: IndexPath) {
        navigationController?.pushViewController(PhotoViewController(with: PhotoModel.photos[index.item], at: index), animated: true)
    }
//    MARK: Будет выводить лист настроек
    func settingsTapped() {
        print("settings tapped")
    }
}
