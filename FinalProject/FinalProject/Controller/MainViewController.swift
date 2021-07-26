//
//  MainViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let networkService: PhotoNetworkServiceProtocol
    
    private var cursor = Cursor()
    
    private var dataSource = [PhotoModel]()
            
    private let photoSearchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
//        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = false
//        sc.searchBar.delegate = self
//        sc.searchBar.placeholder = "Поиск котиков"
        sc.searchBar.autocapitalizationType = .none
        
        return sc
    }()
    
    private lazy var photoSearchBar: UISearchBar = {
        let sb = UISearchBar()
        
        return sb
    }()
    
    private lazy var collectionPhotoView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 0
        let layout = CustomMainLayout()
//        MARK: Размеры ячейки, надо переделать
//        layout.itemSize = CGSize(width: 200, height: 200)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotoCellView.self, forCellWithReuseIdentifier: PhotoCellView.id)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .red
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    init(networkService: PhotoNetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkConstants.query = "cats"
        
        view.backgroundColor = .orange
        

        setupView()
        
        loadData(with: NetworkConstants.query)
        setupPhotoSearchController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        MARK: Скрыли наш нав бар
//        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = .red
        
//        navigationItem.searchController = photoSearchController
    }
    
    private func setupPhotoSearchController() {
//        photoSearchController.searchResultsUpdater = self
//        photoSearchController.obscuresBackgroundDuringPresentation = false
        photoSearchController.searchBar.placeholder = "поиск котиков"
//        let currentQuery = NetworkConstants.query?.trimmingCharacters(in: .whitespacesAndNewlines)
//        if let query = currentQuery, query.isEmpty == false { return }
        
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.searchController = photoSearchController
    }
    
//    MARK: LOAD DATA
    private func loadData(with query: String?) {
        guard let query = query else { return }
        let page = cursor.nextPage()
        networkService.searchPhotos(currentPage: page, searching: query) { self.process($0) }
    }
    
    private func process(_ response: GetPhotosAPIResponse) {
        DispatchQueue.main.async {
            switch response {
            case .success(let data):
                self.dataSource.append(contentsOf: data.results)
                print(self.dataSource.count)
                self.collectionPhotoView.reloadData()
            case .failure(let error):
                self.showAlert(for: error)
            }
        }
    }
    
//    MARK: ALERT об ошибке
    private func showAlert(for error: NetworkServiceError) {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: message(for: error),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
//    MARK: сообщение об ошибке
    private func message(for error: NetworkServiceError) -> String {
        switch error {
        case .network:
            return "Запрос упал"
        case .decodable:
            return "Не смогли распарсить"
        case .buildingURL:
            return "Вы не авторизованы"
        case .unknown:
            print("!!!!НЕ ГРУЗИТ!!!!")
            return "Что-то неизвестное"
        }
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
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        selected(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rowCount = 1
        if indexPath.item == dataSource.count - rowCount {
            loadData(with: NetworkConstants.query)
        }
    }
    
}
//  MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath)
        
        guard let photoCell = cell as? PhotoCellView else { return cell }
        
        
        networkService.loadPhoto(imageUrl: dataSource[indexPath.item].url) { data in
               if let data = data, let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                    photoCell.configure(with: self.dataSource[indexPath.item], image)
                   }
               }
           }
        

        
        photoCell.backgroundColor = .yellow
        
        return photoCell
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
//        guard !photoSearchController.isActive else {
//            return
//        }
        
        navigationController?.pushViewController(PhotoViewController(photo: dataSource[index.item], type: false), animated: true)
    }
//    MARK: Будет выводить лист настроек
    @objc func settingsTapped() {
        print("settings tapped")
    }
}


extension MainViewController: UISearchControllerDelegate {
    //
}


    
    

