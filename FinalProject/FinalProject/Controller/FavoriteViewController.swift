//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit
import CoreData

final class FavoriteViewController: UIViewController {
    
    private let coreDataStack = Container.shared.coreDataStack
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        request.sortDescriptors = [.init(key: "", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: Container.shared.coreDataStack.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    private var photos: [PhotoModel] = [PhotoModel]()
    
    private lazy var deleteAllButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("DelAll", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .magenta
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        try? fetchedResultsController.performFetch()
//        updatePhotos()
        
//        collectionPhotoView.reloadData()
//        MARK: Скрыли наш нав бар
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.barTintColor = .red
    }
    
    @objc func deleteAllButtonTapped() {
        
    }
}

extension FavoriteViewController: ViewProtocol {
    
    func setupView() {
        view.addSubview(collectionPhotoView)
        view.addSubview(deleteAllButton)
        NSLayoutConstraint.activate([
            collectionPhotoView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deleteAllButton.heightAnchor.constraint(equalToConstant: 60),
            deleteAllButton.widthAnchor.constraint(equalToConstant: 60),
            deleteAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
            deleteAllButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
//    private func updatePhotos() {
//        photos = FavoriteStor.shared.putStoredPhotos()
//    }
}

extension FavoriteViewController: UICollectionViewDelegate {
//    MARK: Выбрали ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected(at: indexPath)
        print(indexPath)
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
        
        photoCell.configure(with: photo)

        
        photoCell.backgroundColor = .yellow
        
        return photoCell
    }
    
}

extension FavoriteViewController: UIScrollViewDelegate {
//    MARK: Для скрытия верхнего бара
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.isTracking {
//        navigationController?.navigationBar.isHidden = true
//        }
    }
}

//  MARK: VIEW
extension FavoriteViewController {
    
    func selected(at index: IndexPath) {
        let photoViewController = PhotoViewController(photo: photos[index.item], at: index)
        navigationController?.pushViewController(photoViewController, animated: true)
    }
//    MARK: Будет выводить лист настроек
    @objc func settingsTapped() {
        print("settings tapped")
    }
}

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionPhotoView.reloadData()
    }
}
