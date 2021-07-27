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
    
//    MARK: INFO VIEW
    private lazy var infoView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 20
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let infoHeadLabel: UILabel = {
        let t = UILabel()
        t.text = "Info"
        t.textAlignment = .center
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private let authorHeadLabel: UILabel = {
        let t = UILabel()
        t.text = "Author"
        t.textAlignment = .left
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private let authorTextLabel: UILabel = {
        let t = UILabel()
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 16.0)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private let dimensionHeadLabel: UILabel = {
        let t = UILabel()
        t.text = "Dimension"
        t.textAlignment = .left
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private let dimensionTextLabel: UILabel = {
        let t = UILabel()
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 16.0)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
  
    private let descriptionsHeadLabel: UILabel = {
        let t = UILabel()
        t.text = "Descriptions"
        t.textAlignment = .left
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private let descriptionsTextLabel: UITextView = {
        let t = UITextView()
        t.textAlignment = .left
        t.font = UIFont.systemFont(ofSize: 16.0)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private lazy var infoCloseButton: UIButton = {
        let btm = UIButton(type: .system)
        btm.setTitle("close", for: .normal)
        btm.setTitleColor(.black, for: .normal)
        btm.backgroundColor = .orange
        btm.layer.cornerRadius = 15
        btm.addTarget(self, action: #selector(infoCloseButtonTapped), for: .touchUpInside)
        btm.translatesAutoresizingMaskIntoConstraints = false
        return btm
    }()
    
//     - - - -- - - -- - - - - - - -- - - - - - - -
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
    
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var containerStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [infoHeadLabel])
        stackView.axis = .vertical
        stackView.spacing = 16.0
        return stackView
    }()
    
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
        
        authorTextLabel.text = photo.author
        dimensionTextLabel.text = "\(photo.height) x \(photo.width)"
        descriptionsTextLabel.text = photo.descript

        infoView.isHidden = true
        
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
                self.imageView.image = image
               }
           }
       }
   }
    
    private func configImage(with model: Photo) {

        setupImage(str: photo.url)
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
//        MARK: Шарим фотку
    @objc private func shareButtonTapped() {
        print("Шарим кота")

        guard let item = imageView.image else { return }
        let shareController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        present(shareController, animated: true)
        
    }
    
//        MARK: сохраняем фотку в галерею
    @objc private func saveButtonTapped() {
        print("Сохраняем кота в галерею")
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageWithAlert(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.deletePhotoFromCoreData(photo)
        navigationController?.popViewController(animated: true)
    }


    @objc private func infoButtonTapped() {
//        MARK: покажет лист с инфой, которая будет прилетать при инициализации (строка 14)
        print("Смотрим инфу про кота")

        let vc = BottomInfoListViewController()
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
    @objc func infoCloseButtonTapped() {
        infoView.isHidden = true
    }
    
}

extension FavoritePhotoViewController: ViewProtocol {
    func setupView() {

        view.addSubview(imageView)
        view.addSubview(shareButton)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        view.addSubview(infoButton)
        view.addSubview(infoView)
        
        infoView.addSubview(infoHeadLabel)
        infoView.addSubview(authorHeadLabel)
        infoView.addSubview(authorTextLabel)
        infoView.addSubview(dimensionHeadLabel)
        infoView.addSubview(dimensionTextLabel)
        infoView.addSubview(descriptionsHeadLabel)
        infoView.addSubview(descriptionsTextLabel)
        infoView.addSubview(infoCloseButton)
        
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
            
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            infoButton.widthAnchor.constraint(equalToConstant: 50),
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 120),
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            infoView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 110),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            
            infoHeadLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10),
            infoHeadLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            
            authorHeadLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 15),
            authorHeadLabel.topAnchor.constraint(equalTo: infoHeadLabel.bottomAnchor, constant: 15),
            
            authorTextLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 15),
            authorTextLabel.topAnchor.constraint(equalTo: authorHeadLabel.bottomAnchor, constant: 0),
            
            dimensionHeadLabel.leadingAnchor.constraint(equalTo: infoView.centerXAnchor, constant: 15),
            dimensionHeadLabel.topAnchor.constraint(equalTo: infoHeadLabel.bottomAnchor, constant: 15),
            
            dimensionTextLabel.leadingAnchor.constraint(equalTo: infoView.centerXAnchor, constant: 15),
            dimensionTextLabel.topAnchor.constraint(equalTo: dimensionHeadLabel.bottomAnchor, constant: 0),
            
            descriptionsHeadLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 15),
            descriptionsHeadLabel.topAnchor.constraint(equalTo: authorTextLabel.bottomAnchor, constant: 15),
            
            descriptionsTextLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 15),
            descriptionsTextLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -15),
            descriptionsTextLabel.topAnchor.constraint(equalTo: descriptionsHeadLabel.bottomAnchor, constant: 0),
            descriptionsTextLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            
            infoCloseButton.heightAnchor.constraint(equalToConstant: 30),
            infoCloseButton.widthAnchor.constraint(equalToConstant: 30),
            infoCloseButton.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -10),
            infoCloseButton.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10),
        ])
    }
    
    
}





