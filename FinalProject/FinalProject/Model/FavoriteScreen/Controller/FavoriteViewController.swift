//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit
import CoreData

final class FavoriteViewController: BaseViewController {

    private let networkService = NetworkService()
    private var selectIsActive: Bool = false
    
    lazy var coreDataService: CoreDataService = {
        let cds = CoreDataService()
        cds.delegate = self
        return cds
    }()
    
    
    private lazy var selectButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("Выбрать", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .systemOrange
        btm.layer.cornerRadius = 12.5
        btm.alpha = 0.85
        btm.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var shareButton: CustomButton = {
        let btm = CustomButton(name: "square.and.arrow.up")
        btm.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        btm.isHidden = true
        return btm
    }()
    
    private lazy var deleteButton: CustomButton = {
        let btm = CustomButton(name: "square.and.arrow.up")
        btm.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        btm.isHidden = true
        return btm
    }()

    private lazy var collectionPhotoView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotoCellView.self, forCellWithReuseIdentifier: PhotoCellView.id)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? coreDataService.fetchedResultsController.performFetch()
        navigationController?.navigationBar.isHidden = true
    }
    

    
    private func selected(at index: IndexPath) {
        let photo = coreDataService.fetchedResultsController.object(at: index)
        let pht = PhotoDTO(with: photo)
        let favoritePhotoViewController = FavoritePhotoViewController(photo: pht, delegate: self)
        navigationController?.pushViewController(favoritePhotoViewController, animated: true)
    }
    
    private func selectInterfaceActivate() {
//        MARK: Скрыть всё
        shareButton.isHidden = !shareButton.isHidden
        deleteButton.isHidden = !deleteButton.isHidden

        if let tbc = tabBarController {
            tbc.tabBar.isHidden = !tbc.tabBar.isHidden
        }
    }
    
    @objc private func shareButtonTapped() {
        if let indexPaths = collectionPhotoView.indexPathsForSelectedItems, !indexPaths.isEmpty {
            let photoDispatchGroup = DispatchGroup()
            var photos = [Photo]()
            var images = [UIImage]()
            indexPaths.forEach { indexPath in
                photos.append(coreDataService.fetchedResultsController.object(at: indexPath))
            }
            photos.forEach { photo in
                photoDispatchGroup.enter()
                networkService.loadPhoto(imageUrl: photo.url) { response in
                       switch response {
                       case .success(let image):
                        images.append(image)
                        photoDispatchGroup.leave()
                       case .failure(let error):
                        self.showAlert(for: error)
                       print(error)
                       }
                }
            }
            photoDispatchGroup.notify(queue: DispatchQueue.main) {
                let shareController = UIActivityViewController(activityItems: images, applicationActivities: nil)
                self.present(shareController, animated: true)
                self.decelectAllCells()
            }

        }
    }
    
    private func decelectAllCells() {
        self.collectionPhotoView.indexPathsForSelectedItems?.forEach {
            self.collectionPhotoView.deselectItem(at: $0, animated: false)
        }
    }
    @objc private func deleteButtonTapped() {
        deleteSomePhotos()
    }
    
    @objc private func selectButtonTapped() {
        selectButtonAction()
    }
    
    private func selectButtonAction() {
        selectIsActive = !selectIsActive
        selectInterfaceActivate()
        if selectIsActive {
            selectButton.setTitle("Отмена", for: .normal)
        } else {
            selectButton.setTitle("Выбрать", for: .normal)
            self.decelectAllCells()
        }
    }
    private func deleteSomePhotos() {
        if let paths = collectionPhotoView.indexPathsForSelectedItems, !paths.isEmpty {
            deleteFromCoreData(indexPaths: paths)
        }
    }
    
    private func deleteFromCoreData(indexPaths paths: [IndexPath]) {
        var willDelete = [PhotoDTO]()
        paths.forEach { indexPath in
            let photo = coreDataService.fetchedResultsController.object(at: indexPath)
            willDelete.append(PhotoDTO(with: photo))
        }
        coreDataService.delete(photos: willDelete)
    }
    
    private func loadPhoto(url: String, photoCell: PhotoCellView, index: Int, photoData: PhotoDTO) {
        isLoading = true
        networkService.loadPhoto(imageUrl: url) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let image):
                    photoCell.configure(with: photoData, image)
                case .failure(let error):
                    print(error)
                    self.showAlert(for: error)
                }
                self.isLoading = false
            }
        }
    }
}



extension FavoriteViewController: ViewProtocol {
    
    func setupView() {
        view.addSubview(collectionPhotoView)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(selectButton)
        navigationController?.navigationBar.barStyle = .black
        
        NSLayoutConstraint.activate([
            collectionPhotoView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            shareButton.heightAnchor.constraint(equalToConstant: 60),
            shareButton.widthAnchor.constraint(equalToConstant: 60),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.widthAnchor.constraint(equalToConstant: 60),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            
            selectButton.heightAnchor.constraint(equalToConstant: 25),
            selectButton.widthAnchor.constraint(equalToConstant: 80),
            selectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
        ])
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
//    MARK: Выбрали ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        MARK: РАЗОБРАТЬСЯ ТУТ
        if selectIsActive {
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            selected(at: indexPath)
        }
    }
}

//  MARK: UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {

//    MARK: Не надо
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = coreDataService.fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath)
        let photo = coreDataService.fetchedResultsController.object(at: indexPath)
        let photoData = PhotoDTO(with: photo)
        let imageUrl = photoData.url
        guard let photoCell = cell as? PhotoCellView else { return cell }

        loadPhoto(url: imageUrl, photoCell: photoCell, index: indexPath.item, photoData: photoData)
                
        return photoCell
    }
    
}

extension FavoriteViewController: FavoritePhotoViewControllerDelegate {
    func deletePhotoFromCoreData(_ photo: PhotoDTO) {
        coreDataService.delete(photos: [photo])
    }
}

extension FavoriteViewController: CoreDataSeriviceDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionPhotoView.reloadData()
        }
    }
}
