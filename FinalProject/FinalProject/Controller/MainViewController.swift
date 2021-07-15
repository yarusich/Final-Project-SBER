//
//  MainViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var cursor: Cursor?
    
    private var dataSource = [GetPhotosDataResponse]()
    
    private var photoModel = PhotoModel()
    
    private var photos = PhotoModel().photos
        
    private let photoSearchController = UISearchController(searchResultsController: nil)
    
    private lazy var collectionPhotoView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 0
        let layout = CustomLayout()
//        MARK: Размеры ячейки, надо переделать
//        layout.itemSize = CGSize(width: 200, height: 200)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotoCellView.self, forCellWithReuseIdentifier: PhotoCellView.id)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .red
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
        
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
        
        photoModel.delegate = self
        
        setupPhotoSearchController()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        MARK: Скрыли наш нав бар
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = .red
        
    }
    
    private func setupPhotoSearchController() {
        photoSearchController.searchResultsUpdater = self
        photoSearchController.obscuresBackgroundDuringPresentation = false
        photoSearchController.searchBar.placeholder = "поиск котиков"
        navigationItem.searchController = photoSearchController
        definesPresentationContext = true
    }
}

extension MainViewController: ViewProtocol {
    
    func setupView() {
        view.addSubview(collectionPhotoView)
        NSLayoutConstraint.activate([
            collectionPhotoView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainViewController: UICollectionViewDelegate {
//    MARK: Выбрали ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected(at: indexPath)
    }
    
}
//  MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.count
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath) as? cellPhotoCellView
        
//        cell.configView(with: photos[indexPath.item].image)
        
        cell.backgroundColor = .yellow
        return cell
    }
    
}

extension MainViewController: UIScrollViewDelegate {
//    MARK: Для скрытия верхнего бара
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.isTracking {
//        navigationController?.navigationBar.isHidden = true
//        }
    }
}

//  MARK: VIEW
extension MainViewController {
    
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
