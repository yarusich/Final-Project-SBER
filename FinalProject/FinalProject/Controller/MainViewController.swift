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
    
    private var dataSource = [GetPhotosDataResponse]()
            
    private let photoSearchController = UISearchController(searchResultsController: nil)
    
//    private lazy var photoSearchBar: UISearchBar = {}()
    
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
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    init(networkService: PhotoNetworkServiceProtocol) {

        self.networkService = networkService
//        MARK: ДЛЯ ЧЕГО ЭТО?
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        setupPhotoSearchController()
        setupView()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        MARK: Скрыли наш нав бар
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = .red
        
    }
    
    private func setupPhotoSearchController() {
//        photoSearchController.searchResultsUpdater = self
        photoSearchController.obscuresBackgroundDuringPresentation = false
        photoSearchController.searchBar.placeholder = "поиск котиков"
        navigationItem.searchController = photoSearchController
        definesPresentationContext = true
    }
    
//    MARK: LOAD DATA
    private func loadData() {
        let page = cursor.nextPage()
        networkService.searchPhotos(currentPage: page, searching: "") { self.process($0) }   //after починить
    }
    
    private func process(_ response: GetPhotosAPIResponse) {
        DispatchQueue.main.async {
            switch response {
            case .success(let data):
//                self.cursor?.page =   починить курсор
//                MARK: Видимо кэшируем нужные данные?
                self.dataSource.append(contentsOf: data.results)
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
        selected(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rowCount = 5
        if indexPath.item == dataSource.count - rowCount {
            loadData()
        }
    }
    
}
//  MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.count
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        MARK: Переделать вот так, чтобы сразу уходило в ячейку, так лучше
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath) (cell as? PhotoCellView)?.configure(with: dataSource[indexPath.item])
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath)
        
        guard let photoCell = cell as? PhotoCellView else { return cell }
//        MARK: Загрузку по урлу лучше сделать здесь (перенести, если получится)
        photoCell.configure(with: dataSource[indexPath.item])
//        cell.configView(with: photos[indexPath.item].image)
        
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
        navigationController?.pushViewController(PhotoViewController(photo: dataSource[index.item], at: index), animated: true)
    }
//    MARK: Будет выводить лист настроек
    func settingsTapped() {
        print("settings tapped")
    }
}
//  MARK: MODEL
extension MainViewController: PhotoModelDelegate {
    
    
}

