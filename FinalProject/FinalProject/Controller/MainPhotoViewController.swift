//
//  MainPhotoViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 12.07.2021.
//

import UIKit

final class MainPhotoViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    private let currentUserKey = "currentUser"
    private let coreDataStack = Container.shared.coreDataStack
    private let photo: PhotoDTO
    

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
    
    private lazy var likeButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("like", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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
    

    
//    lazy var doubleTapGesture: UITapGestureRecognizer = {
//        let recognizer = UITapGestureRecognizer()
//        recognizer.addTarget(self, action: #selector(viewDoubleTap))
//        return recognizer
//    }()
    
    init(photo: PhotoDTO) {
        self.photo = photo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        imageScrollView.hideDelegate = self
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
    
    private func configImage(with model: PhotoDTO) {
//        imageView.setupImage(str: model.url)
        setupImage(str: photo.url)
//        imageView.contentMode = .scaleAspectFit
//        MARK: Посмотреть оба вариант клипа
//        imageView.clipsToBounds = true
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))

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
        
//        guard let item = imageView.image else { return }
        let photo = imageScrollView.getImage()
        let shareController = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        present(shareController, animated: true)
        
    }
    
//        MARK: сохраняем фотку в галерею
    @objc private func saveButtonTapped() {
        print("Сохраняем кота в галерею")
//        guard let image = imageView.image else { return }
        let image = imageScrollView.getImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageWithAlert(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func likeButtonTapped() {
//        MARK: сохраняем фотку в раздел фоток
        print("Сохраняем кота в фаворит(кор дату)")
//        MARK: backgroundContext видимо долго слишком
        let context = coreDataStack.mainContext
        context.performAndWait {
            let 🦁 = Photo(context: context, with: photo)
            
//            print(data)
            
        }
//        try? context.save()
        do {
            try context.save()
            print("context.save")
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    @objc private func infoButtonTapped() {
//        MARK: покажет лист с инфой, которая будет прилетать при инициализации (строка 14)
        print("Смотрим инфу про кота")
//        let photoDTO = PhotoDTO(with: photo)
        let vc = BottomInfoListViewController(photo: photo)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    private func hideAllInterface() {
//        MARK: Скрыть всё
        shareButton.isHidden = !shareButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        likeButton.isHidden = !likeButton.isHidden
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
    @objc func infoCloseButtonTapped() {
//        infoView.isHidden = true
    }
    
}

extension MainPhotoViewController: ViewProtocol {
    func setupView() {

//        view.addSubview(imageView)
        view.addSubview(imageScrollView)
        view.addSubview(shareButton)
        view.addSubview(saveButton)
        view.addSubview(likeButton)
        view.addSubview(infoButton)
//        view.addSubview(infoView)
        
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
            
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            infoButton.widthAnchor.constraint(equalToConstant: 50),
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])

    }
    
    
}

extension MainPhotoViewController: ImageScrollViewDelegate {
    func hideInterface() {
        hideAllInterface()
    }
    
    
}



