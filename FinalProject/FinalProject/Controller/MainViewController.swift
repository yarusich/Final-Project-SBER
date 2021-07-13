//
//  MainViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import UIKit

final class MainViewController: UIViewController {
    

    
    
    private var photoModel = PhotoModel()
    
    var photos = PhotoModel().photos
    
    private var mainView = MainView()
        
    private let photoSearchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        self.view = mainView
    }
    
//    MARK: В МОДЕЛЬ!
    private var filteredPhotos = [UIImage]()
    private var searchBarIsEmpty: Bool {
        guard let text = photoSearchController.searchBar.text else { return false }
        return text.isEmpty
    }
//    - - - - - - - -
    
    private var isFiltering: Bool {
        return photoSearchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        setupPhotoSearchController()
        
        mainView.setupView()
        mainView.delegate = self
        photoModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        MARK: Скрыли наш нав бар
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupPhotoSearchController() {
        photoSearchController.searchResultsUpdater = self
        photoSearchController.obscuresBackgroundDuringPresentation = false
        photoSearchController.searchBar.placeholder = "поиск котиков"
        navigationItem.searchController = photoSearchController
        definesPresentationContext = true
    }
    
}

//  MARK: VIEW
extension MainViewController: MainViewDelegate {
    
    func selected(at index: IndexPath) {
        navigationController?.pushViewController(PhotoViewController(with: photoModel.defoltPhotos[index.item], at: index), animated: true)
    }
//    MARK: Будет выводить лист настроек
    func settingsTapped() {
        print("settings tapped")
    }
}
//  MARK: MODEL
extension MainViewController: PhotoModelDelegate {
    
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText)
    }
//    MARK: Фильтрация контента
    private func filterContentForSearchText(_ searhText: String) {
        let searchingPhoto = photoModel.getPhotos(searhText)
        filteredPhotos = searchingPhoto.map { $0.image }
        
        
        
    }
}
