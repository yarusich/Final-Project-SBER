//
//  PhotoViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 12.07.2021.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    private var index: IndexPath?
    private var photo: UIImage?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
//        MARK: Перенести куда-то
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
//        iv.addGestureRecognizer(<#T##gestureRecognizer: UIGestureRecognizer##UIGestureRecognizer#>)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var doubleTapGesture: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(viewDoubleTap))
        return recognizer
    }()
    
    init(with photo: UIImage, at index: IndexPath) {
        super.init(nibName: nil, bundle: nil)
        self.photo = photo
        imageView.image = photo
        self.index = index
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
        setupView()
    }
    
    @objc func viewDoubleTap() {
        print("тапнули по коту")
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
