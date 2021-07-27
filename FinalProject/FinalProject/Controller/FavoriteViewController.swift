//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit
import CoreData

final class FavoriteViewController: UIViewController {
    
    
    

    
    private let networkService = NetworkService()
    
    private var selectIsActive: Bool = false
    
    private var selectedPhotos = [PhotoModel]()
    
    private let coreDataStack = Container.shared.coreDataStack
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        request.sortDescriptors = [.init(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: coreDataStack.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    private lazy var selectButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("Выбрать", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 12.5
        btm.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var shareButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("share", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        btm.isHidden = true
        return btm
    }()
    
    private lazy var deleteButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("delete", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        btm.isHidden = true
        return btm
    }()
    
    private lazy var deleteAllButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("DelAll", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        btm.isHidden = true
        
        return btm
    }()
    
    private lazy var collectionPhotoView: UICollectionView = {
        let layout = CustomMainLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotoCellView.self, forCellWithReuseIdentifier: PhotoCellView.id)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .red
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .magenta
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? fetchedResultsController.performFetch()
        navigationController?.navigationBar.isHidden = true
        
//        collectionPhotoView.reloadData()
//        MARK: Скрыли наш нав бар
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.barTintColor = .red
    }
    
    @objc func deleteAllButtonTapped() {
        deleteAllPhotos()
    }
    
    private func selected(at index: IndexPath) {
        let photo = fetchedResultsController.object(at: index)
//        let photoModel = ConverterPhoto.photoToPhotoModel(photo)
        let favoritePhotoViewController = FavoritePhotoViewController(photo: photo, delegate: self)
        navigationController?.pushViewController(favoritePhotoViewController, animated: true)
//        navigationController?.pushViewController(FavoritePhotoViewController(photo: photo), animated: true)
    }
    
    private func selectInterfaceActivate() {
//        MARK: Скрыть всё
        shareButton.isHidden = !shareButton.isHidden
        deleteButton.isHidden = !deleteButton.isHidden
        deleteAllButton.isHidden = !deleteAllButton.isHidden
        
        if let tbc = tabBarController {
            tbc.tabBar.isHidden = !tbc.tabBar.isHidden
        }
//        if let nv = navigationController {
//            nv.navigationBar.isHidden = !nv.navigationBar.isHidden
//        }
    }
    
    @objc func shareButtonTapped() {
        
        
        if let indexPaths = collectionPhotoView.indexPathsForSelectedItems, !indexPaths.isEmpty {
            let photoDispatchGroup = DispatchGroup()
            var photos = [Photo]()
            var images = [UIImage]()
            indexPaths.forEach { indexPath in
                photos.append(fetchedResultsController.object(at: indexPath))
            }
            photos.forEach { photo in
                photoDispatchGroup.enter()
                networkService.loadPhoto(imageUrl: photo.url) { data in
                    if let data = data, let image = UIImage(data: data) {
                        images.append(image)
                        photoDispatchGroup.leave()
                    }
                }
            }
            photoDispatchGroup.notify(queue: DispatchQueue.main) {
                let shareController = UIActivityViewController(activityItems: images, applicationActivities: nil)
                self.present(shareController, animated: true)
                
            }
        }
    }
    
    @objc func deleteButtonTapped() {
        deleteSomePhotos()
    }
    
    @objc func selectButtonTapped() {
        selectButtonAction()
    }
    

    
    private func selectButtonAction() {
        selectIsActive = !selectIsActive
        selectInterfaceActivate()
        if selectIsActive {
            selectButton.setTitle("Отмена", for: .normal)
        } else {
            selectButton.setTitle("Выбрать", for: .normal)
            collectionPhotoView.indexPathsForSelectedItems?.forEach {
                collectionPhotoView.deselectItem(at: $0, animated: false)
            }
            
        }
        
    }
    private func deleteSomePhotos() {
        if let paths = collectionPhotoView.indexPathsForSelectedItems, !paths.isEmpty {
            deleteFromCoreData(indexPaths: paths)
        }
    }
    
    private func deleteFromCoreData(indexPaths paths: [IndexPath]) {
        var willDelete = [Photo]()
        paths.forEach { indexPath in
            willDelete.append(fetchedResultsController.object(at: indexPath))
        }
        coreDataStack.delete(photos: willDelete)
    }
}



extension FavoriteViewController: ViewProtocol {
    
    func setupView() {
        view.addSubview(collectionPhotoView)
        view.addSubview(deleteAllButton)
        view.addSubview(shareButton)
        view.addSubview(deleteButton)
        view.addSubview(selectButton)
        
        NSLayoutConstraint.activate([
            collectionPhotoView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deleteAllButton.heightAnchor.constraint(equalToConstant: 60),
            deleteAllButton.widthAnchor.constraint(equalToConstant: 60),
            deleteAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            deleteAllButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            
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
        
        if selectIsActive {
//            let selectedPhoto = fetchedResultsController.object(at: indexPath)
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            selected(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    func deleteAllPhotos() {
        coreDataStack.deleteAll()
    }
 
    
    }

//  MARK: UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {

//    MARK: Не надо
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath)
        let photo = fetchedResultsController.object(at: indexPath)
        guard let photoCell = cell as? PhotoCellView else { return cell }
        let photoModel = ConverterPhoto.photoToPhotoModel(photo)
        

        networkService.loadPhoto(imageUrl: photo.url) { data in
               if let data = data, let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                    photoCell.configure(with: photoModel, image)
                   }
               }
           }
        
        
        photoCell.backgroundColor = .yellow
        
        return photoCell
    }
    
}

//extension FavoriteViewController: UIScrollViewDelegate {
////    MARK: Для скрытия верхнего бара
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        if scrollView.isTracking {
////        navigationController?.navigationBar.isHidden = true
////        }
//    }
//}

//  MARK: VIEW
//extension FavoriteViewController {
//
////    func selected(at index: IndexPath) {
////        let photoViewController = PhotoViewController(photo: photos[index.item], at: index)
////        navigationController?.pushViewController(photoViewController, animated: true)
////    }

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionPhotoView.reloadData()
    }
}


extension FavoriteViewController: FavoritePhotoViewControllerDelegate {
    func deletePhotoFromCoreData(_ photo: Photo) {
        coreDataStack.delete(photos: [photo])
    }
    
    
}
