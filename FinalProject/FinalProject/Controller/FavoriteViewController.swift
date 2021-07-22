//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 17.07.2021.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    private let photos: [PhotoModel] = FavoriteStor.shared.putStoredPhotos()
    
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
//        MARK: Скрыли наш нав бар
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.barTintColor = .red
    }
}

extension FavoriteViewController: ViewProtocol {
    
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

extension FavoriteViewController: UICollectionViewDelegate {
//    MARK: Выбрали ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected(at: indexPath)
    }
    
}
//  MARK: UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath)
        
        guard let photoCell = cell as? PhotoCellView else { return cell }
//        MARK: Загрузку по урлу лучше сделать здесь?
        photoCell.configure(with: photos[indexPath.item])

        
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
        navigationController?.pushViewController(PhotoViewController(photo: photos[index.item], at: index), animated: true)
    }
//    MARK: Будет выводить лист настроек
    @objc func settingsTapped() {
        print("settings tapped")
    }
}

