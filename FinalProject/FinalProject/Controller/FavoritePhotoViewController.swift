//
//  FavoritePhotoViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 26.07.2021.
//

import UIKit

protocol FavoritePhotoViewControllerDelegate: AnyObject {
    func deletePhotoFromCoreData(_ photo: Photo)
}

final class FavoritePhotoViewController: UIViewController {
    
    weak var delegate: FavoritePhotoViewControllerDelegate?
    
    private let networkService = NetworkService()
    
    private let currentUserKey = "currentUser"
    private let coreDataStack = Container.shared.coreDataStack
    private let photo: Photo
    
   
    private lazy var shareButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("share", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var saveButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("save", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var deleteButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("del", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    private lazy var infoButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("info", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
    
    private lazy var imageScrollView: ImageScrollView = {
        let i = ImageScrollView(frame: view.bounds)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
//    private lazy var imageScrollView: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
    

    
//    lazy var doubleTapGesture: UITapGestureRecognizer = {
//        let recognizer = UITapGestureRecognizer()
//        recognizer.addTarget(self, action: #selector(viewDoubleTap))
//        return recognizer
//    }()
    
    init(photo: Photo, delegate: FavoritePhotoViewControllerDelegate) {
        self.delegate = delegate
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        
        configImage(with: photo)
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
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
    
    func setupImage(str url: String) {
       networkService.loadPhoto(imageUrl: url) { data in
           if let data = data, let image = UIImage(data: data) {
               DispatchQueue.main.async {
                self.imageScrollView.set(image: image)
               }
           }
       }
   }
    
    private func configImage(with model: Photo) {

        setupImage(str: photo.url)
//        imageView.contentMode = .scaleAspectFit
//        MARK: Посмотреть оба вариант клипа
//        imageScrollView.clipsToBounds = true
        imageScrollView.isUserInteractionEnabled = true
        imageScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
//        imageScrollView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(viewPinched(_:))))
//        imageScrollView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:))))
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
//        MARK: Шарим фотку
    @objc private func shareButtonTapped() {
        print("Шарим кота")

//        guard let item = imageScrollView.image else { return }
        let image = imageScrollView.getImage()
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true)
        
    }
    
//        MARK: сохраняем фотку в галерею
    @objc private func saveButtonTapped() {
        print("Сохраняем кота в галерею")
//        guard let image = imageScrollView.image else { return }
        let image = imageScrollView.getImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageWithAlert(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.deletePhotoFromCoreData(photo)
        navigationController?.popViewController(animated: true)
    }


    @objc private func infoButtonTapped() {
//        MARK: покажет лист с инфой, которая будет прилетать при инициализации (строка 14)
        print("Смотрим инфу про кота")

//        let vc = BottomInfoListViewController(photo: photo)
        let photoDTO = PhotoDTO(with: photo)
        let vc = BottomInfoListViewController(photo: photoDTO)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    private func hideInterface() {
//        MARK: Скрыть всё
        shareButton.isHidden = !shareButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        deleteButton.isHidden = !deleteButton.isHidden
        infoButton.isHidden = !infoButton.isHidden
        
        if let nv = navigationController {
            nv.navigationBar.isHidden = !nv.navigationBar.isHidden
        }
    }
    
    @objc private func saveImageWithAlert(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                let alertController = UIAlertController(title: "Ошибка сохранения", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertController, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Успешно", message: "Фото было сохранено в галерею устройства", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
}

extension FavoritePhotoViewController: ViewProtocol {
    func setupView() {

        view.addSubview(imageScrollView)
        view.addSubview(shareButton)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        view.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            infoButton.widthAnchor.constraint(equalToConstant: 50),
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    
}





