//
//  MainView.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import UIKit

final class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    

    private lazy var collectionPhotoView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 0
        let layout = CustomLayout()
//        MARK: Размеры ячейки по сути, надо придумать что-то
//        layout.itemSize = CGSize(width: 200, height: 200)
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotoCellView.self, forCellWithReuseIdentifier: PhotoCellView.id)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .red
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
}

extension MainView: ViewProtocol {
    
    func setupView() {
        addSubview(collectionPhotoView)
        
        NSLayoutConstraint.activate([
            collectionPhotoView.topAnchor.constraint(equalTo: topAnchor),
            collectionPhotoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionPhotoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionPhotoView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension MainView: UICollectionViewDelegate {
//    MARK: Выбрали ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selected(at: indexPath)
    }
}

extension MainView: UICollectionViewDataSource {
//    MARK: Секции не нужны
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        MARK: Передать сюда нашу переиспользуемую ячейку
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath) as! PhotoCellView
//        MARK: Сложная штука с протоколом, сделать
        //        cell.configView(with: delegate.)
        
//        let item = PhotoModel.photos[indexPath.item]
        cell.configView(with: PhotoModel.photos[indexPath.item])
        cell.backgroundColor = .yellow
        return cell
    }
}

extension MainView: UIScrollViewDelegate {
//    MARK: Для скрытия верхнего бара
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

