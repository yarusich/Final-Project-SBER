//
//  MainView.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

import UIKit

final class MainView: UIView {
    
    private var photos = PhotoModel().defoltPhotos
    
    weak var delegate: MainViewDelegate?
    
    
    private lazy var searchView: UISearchBar = {
        let sv = UISearchBar()
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var settingsButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.backgroundColor = .blue
        btm.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
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
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }

    
    @objc func settingsButtonTapped() {
        delegate?.settingsTapped()
    }
    
    
}

extension MainView: ViewProtocol {
    
    func setupView() {
        addSubview(collectionPhotoView)
//        addSubview(searchView)
//        addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
//            collectionPhotoView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            collectionPhotoView.topAnchor.constraint(equalTo: topAnchor),
            collectionPhotoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionPhotoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionPhotoView.trailingAnchor.constraint(equalTo: trailingAnchor)
            
//            searchView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            searchView.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -10),
//
//            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
//            settingsButton.bottomAnchor.constraint(equalTo: collectionPhotoView.topAnchor, constant: -10),
//            settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor, constant: 0),
//            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
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
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellView.id, for: indexPath) as! PhotoCellView
        //        cell.configView(with: delegate.)
        
//        cell.configView(with: photos[indexPath.item].image)
        cell.configView(with: photos[indexPath.item])
        cell.backgroundColor = .yellow
        return cell
    }
    
}

extension MainView: UIScrollViewDelegate {
//    MARK: Для скрытия верхнего бара
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

