//
//  MainPhotoViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 12.07.2021.
//

import UIKit

final class MainPhotoViewController: BaseViewController {
    
    private let networkService = NetworkService()
    private let currentUserKey = "currentUser"
    private let photo: PhotoDTO
    private let coreDataService = CoreDataService()
    
    lazy var mainPhotoView: MainPhotoView = {
        let v = MainPhotoView(frame: view.frame)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

//    private lazy var shareButton: CustomButton = {
//        let btm = CustomButton(name: "square.and.arrow.up")
//        btm.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
//        return btm
//    }()
//
//    private lazy var saveButton: CustomButton = {
//        let btm = CustomButton(name: "square.and.arrow.down")
//        btm.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
//        return btm
//    }()
//
//    private lazy var likeButton: CustomButton = {
//        let btm = CustomButton(name: "suit.heart.fill")
//        btm.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
//        return btm
//    }()
//
//    private lazy var infoButton: CustomButton = {
//        let btm = CustomButton(name: "info.circle")
//        btm.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
//        return btm
//    }()
//
//
    private lazy var imageScrollView: ImageScrollView = {
        let i = ImageScrollView(frame: view.bounds)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    init(photo: PhotoDTO) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        imageScrollView.hideDelegate = self
        mainPhotoView.delegate = self
        loadPhoto(url: photo.url, photoData: photo)
        setupView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            tabBarController?.tabBar.isHidden = false
        }
    }
    


    @objc private func viewTapped() {
        hideInterface()
    }

    @objc private func shareButtonTapped() {
        let photo = imageScrollView.getImage()
        let shareController = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        present(shareController, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        let image = imageScrollView.getImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageWithAlert(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func likeButtonTapped() {
        coreDataService.save(photos: [photo])
    }
    
    @objc private func infoButtonTapped() {
        let vc = BottomInfoListViewController(photo: photo)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    private func hideAllInterface() {
        mainPhotoView.hideAllInterface()
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
    
    private func loadPhoto(url: String, photoData: PhotoDTO) {
        networkService.loadPhoto(imageUrl: url) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let image):
                    self.imageScrollView.set(image: image)
                case .failure(let error):
                    print(error)
                    self.showAlert(for: error)
                }
            }
        }
    }
}

extension MainPhotoViewController: ViewProtocol {
    func setupView() {

        view.addSubview(imageScrollView)
//        view.addSubview(shareButton)
//        view.addSubview(saveButton)
//        view.addSubview(likeButton)
//        view.addSubview(infoButton)
        
        NSLayoutConstraint.activate([

            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            shareButton.heightAnchor.constraint(equalToConstant: 55),
//            shareButton.widthAnchor.constraint(equalToConstant: 55),
//            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
//            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
//
//            saveButton.heightAnchor.constraint(equalToConstant: 55),
//            saveButton.widthAnchor.constraint(equalToConstant: 55),
//            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
//            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
//
//            likeButton.heightAnchor.constraint(equalToConstant: 55),
//            likeButton.widthAnchor.constraint(equalToConstant: 55),
//            likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
//            likeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
//
//            infoButton.heightAnchor.constraint(equalToConstant: 55),
//            infoButton.widthAnchor.constraint(equalToConstant: 55),
//            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
//            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
}

extension MainPhotoViewController: ImageScrollViewDelegate {
    func hideInterface() {
        hideAllInterface()
    }
    
    
}

extension MainPhotoViewController: MainPhotoViewProtocol {
    func share() {
        shareButtonTapped()
    }
    
    func save() {
        saveButtonTapped()
    }
    
    func like() {
        likeButtonTapped()
    }
    
    func info() {
        infoButtonTapped()
    }
    
    
}



