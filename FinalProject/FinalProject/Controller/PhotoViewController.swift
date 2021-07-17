//
//  PhotoViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 12.07.2021.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    
    private let networkService = NetworkService()
    private var index: IndexPath
    private var photo: GetPhotosDataResponse
//  MARK:    private let photoItem: GetPhotosDataResponse  //ВНИЗУ УЖЕ ЕСТЬ ВСЕ ЗАГОТОВКИ МЕТОДОВ
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
//        MARK: Перенести куда-то
//        iv.addGestureRecognizer(<#T##gestureRecognizer: UIGestureRecognizer##UIGestureRecognizer#>)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var doubleTapGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(viewDoubleTap))
        return recognizer
    }()
    
    init(photo: GetPhotosDataResponse, at index: IndexPath) {
        self.photo = photo
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        configImage(with: photo)
        setupView()
    }
    
    private func configImage(with model: GetPhotosDataResponse) {
//       MARK: получаем отсюда ссылку и качаем картинку
        loadPhotoData(str: model.urls.regular)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    private func loadPhotoData(str: String) {
        networkService.loadPhoto(imageUrl: str) { data in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    
    @objc func viewDoubleTap() {
//        MARK: двойной тап приближает и отдаляет, одинарный - скрывает интерфейс
        print("тапнули по коту")
    }
    
    @objc func tapInfoButton() {
//        MARK: покажет лист с инфой, которая будет прилетать при инициализации (строка 14)
    }
    
    @objc func tapShareButton() {
//        MARK: Шарим фотку
    }
    
    @objc func tapLikeButton() {
//        MARK: сохраняем фотку в раздел фоток (урл или файл)
    }
    
    @objc func tapSaveButton() {
//        MARK: сохраняем фотку в галерею
    }
}

extension PhotoViewController: ViewProtocol {
    func setupView() {
        view.addSubview(imageView)
        imageView.addGestureRecognizer(doubleTapGesture)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}
