//
//  PhotoViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 12.07.2021.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    private let currentUserKey = "currentUser"
    private let coreDataStack = Container.shared.coreDataStack
    private let photo: PhotoModel
    
    
    
    
    private lazy var shareButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("share", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .red
        btm.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var saveButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("save", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .red
        btm.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var likeButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("like", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .red
        btm.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var infoButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("info", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .red
        btm.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    
    private lazy var imageView: PhotoView = {
        let iv = PhotoView()
//        MARK: Перенести куда-то
//        iv.addGestureRecognizer(<#T##gestureRecognizer: UIGestureRecognizer##UIGestureRecognizer#>)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
//    lazy var doubleTapGesture: UITapGestureRecognizer = {
//        let recognizer = UITapGestureRecognizer()
//        recognizer.addTarget(self, action: #selector(viewDoubleTap))
//        return recognizer
//    }()
    
    init(photo: PhotoModel) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
        configImage(with: photo)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == nil {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    private func configImage(with model: PhotoModel) {
        imageView.setupImage(str: model.url)
        imageView.contentMode = .scaleAspectFit
//        MARK: Посмотреть оба вариант клипа
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(viewPinched(_:))))
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:))))
    }
/// ТАЩИМ
    @objc private func viewPanned(_ recognizer: UIPanGestureRecognizer) {
        print("тащим кота")
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
/// ЩИПОК
    @objc private func viewPinched(_ recognizer: UIPinchGestureRecognizer) {
        print("щиплем кота")
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
/// ДАБЛ ТАП
    @objc private func viewDoubleTapped() {
//        MARK: двойной тап приближает и отдаляет
        print("тапнули по коту два раза")
    }
/// ОДИНАРНЫЙ ТАП
    @objc private func viewTapped() {
//        MARK: одинарный тап - скрывает интерфейс
        print("тапнули по коту один раз")
        hideInterface()
    }
    
    @objc private func shareButtonTapped() {
//        MARK: Шарим фотку
        print("Шарим кота")
    }
    
    @objc private func saveButtonTapped() {
//        MARK: сохраняем фотку в галерею
        print("Сохраняем кота в галерею")
    }
    
    @objc private func likeButtonTapped() {
//        MARK: сохраняем фотку в раздел фоток
        print("Сохраняем кота в фаворит(кор дату)")
//        MARK: backgroundContext видимо долго слишком
        let context = coreDataStack.mainContext
        context.performAndWait {
            let photoData = Photo(context: context)
            photoData.author = photo.author
            photoData.descript = photo.descript
            photoData.height = photo.height
            photoData.width = photo.width
            photoData.id = photo.id
            photoData.url = photo.url
//            photoData.user = UserDefaults.standard.string(forKey: currentUserKey)
            photoData.user = "Richard"
        }
        try? context.save()
    }
    
    @objc private func infoButtonTapped() {
//        MARK: покажет лист с инфой, которая будет прилетать при инициализации (строка 14)
        print("Смотрим инфу про кота")
        print(photo.descript)
        print("\(photo.width) x \(photo.height)")
        print(photo.url)
        print(photo.author)
    }
    
    private func saveToGallery() {
        guard let image = imageView.image else { return }
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    private func hideInterface() {
//        MARK: Скрыть всё
        shareButton.isHidden = !shareButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        likeButton.isHidden = !likeButton.isHidden
        infoButton.isHidden = !infoButton.isHidden
        
        if let nv = navigationController {
            nv.navigationBar.isHidden = !nv.navigationBar.isHidden
        }
    }
}

extension PhotoViewController: ViewProtocol {
    func setupView() {
        view.addSubview(imageView)
        view.addSubview(shareButton)
        view.addSubview(saveButton)
        view.addSubview(likeButton)
        view.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            infoButton.widthAnchor.constraint(equalToConstant: 50),
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    
}


