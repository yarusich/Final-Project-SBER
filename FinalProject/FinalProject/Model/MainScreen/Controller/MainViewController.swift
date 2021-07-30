//
//  MainViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import UIKit

final class MainViewController: BaseViewController {
    
    
    private let networkService: PhotoNetworkServiceProtocol
    private let userDefaultsService = UserDefaultsService()
    private var cursor = Cursor()
    private var dataSource = [PhotoDTO]()
    
    private var query = String() {
        didSet {
            cursor.zeroPage()
        }
    }
    
    private let photoSearchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = true
        sc.searchBar.autocapitalizationType = .none
        sc.searchBar.becomeFirstResponder()
        return sc
    }()
    
    private func setupPhotoSearchController() {
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext = true
        navigationItem.searchController = photoSearchController
        photoSearchController.searchBar.delegate = self
    }
    
    private lazy var collectionPhotoView: UICollectionView = {
        let layout = CustomMainLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotoCellView.self, forCellWithReuseIdentifier: PhotoCellView.id)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .systemGroupedBackground
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
        query = userDefaultsService.getCurrentQuery()
        
        
        
        setupView()
        loadData(with: query)
        setupPhotoSearchController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        MARK: Скрыли наш нав бар
//        navigationController?.navigationBar.isHidden = false
//        MARK: Устанавливаем запрос по-умолчанию здесь
        photoSearchController.searchBar.placeholder = userDefaultsService.getCurrentQuery()
    }
    
//    MARK: LOAD DATA
    private func loadData(with query: String) {
        isLoading = true
        let page = cursor.nextPage()
        networkService.searchPhotos(currentPage: page, searching: query) { [weak self] response in
            guard let self = self else { return }
            self.process(response)
            
        }
    }
    
    private func process(_ response:  Result<GetPhotosResponse, NetworkServiceError>) {
        DispatchQueue.main.async {
            switch response {
            case .success(let data):
                self.dataSource.append(contentsOf: data.results)
                self.collectionPhotoView.reloadData()
            case .failure(let error):
                self.showAlert(for: error)
            }
            self.isLoading = false
        }
    }
    
    private func loadPhoto(url: String, photoCell: PhotoCellView, photoData: PhotoDTO) {
        networkService.loadPhoto(imageUrl: url) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let image):
                    photoCell.configure(with: photoData, image)
                case .failure(let error):
                    self.showAlert(for: error)
                }
            }
        }
    }
}

extension MainViewController: ViewProtocol {
    
    func setupView() {
        view.addSubview(collectionPhotoView)
        

//        MARK: погуглить, можно ли сделать более прозрачным
        navigationController?.navigationBar.isTranslucent = true
//        MARK: выбрать вариант:
        navigationController?.navigationBar.barStyle = .black
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
//        MARK: подгрузка
        let rowCount = 1
        if indexPath.item == dataSource.count - rowCount, !isLoading {
            loadData(with: query)
            isLoading = true
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
        let imageUrl = dataSource[indexPath.item].url
        let photoData = dataSource[indexPath.item]

        loadPhoto(url: imageUrl, photoCell: photoCell, photoData: photoData)
        
        
        return photoCell
    }
    
}

//  MARK: VIEW
extension MainViewController {
    
    func selected(at index: IndexPath) {
        guard !photoSearchController.isActive else {
            return
        }
        
        navigationController?.pushViewController(MainPhotoViewController(photo: dataSource[index.item]), animated: true)
    }
//    MARK: Будет выводить лист настроек
    @objc func settingsTapped() {
        print("settings tapped")
    }
}


extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        print("text: \(text)")
        query = text
        if text == ""  { return }
        dataSource.removeAll()
        loadData(with: text)
        collectionPhotoView.reloadData()
    }
}



    
    

