//
//  MainPhotoView.swift
//  FinalProject
//
//  Created by Антон Сафронов on 07.07.2021.
//

protocol MainPhotoViewProtocol: AnyObject {
    func share()
    func save()
    func like()
    func info()
}
//shareButtonTapped
//saveButtonTapped
//likeButtonTapped
//infoButtonTapped

import UIKit

class MainPhotoView: UIView {
    
    weak var delegate: MainPhotoViewProtocol?
    private lazy var shareButton: CustomButton = {
        let btm = CustomButton(name: "square.and.arrow.up")
        btm.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return btm
    }()
    
    private lazy var saveButton: CustomButton = {
        let btm = CustomButton(name: "square.and.arrow.down")
        btm.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return btm
    }()
    
    private lazy var likeButton: CustomButton = {
        let btm = CustomButton(name: "suit.heart.fill")
        btm.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return btm
    }()
    
    private lazy var infoButton: CustomButton = {
        let btm = CustomButton(name: "info.circle")
        btm.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return btm
    }()
  
    
    private lazy var imageScrollView: ImageScrollView = {
        let i = ImageScrollView(frame: bounds)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElement()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func hideAllInterface() {
        shareButton.isHidden = !shareButton.isHidden
        saveButton.isHidden = !saveButton.isHidden
        likeButton.isHidden = !likeButton.isHidden
        infoButton.isHidden = !infoButton.isHidden
    
    
    }
    
    private func setupElement() {
        addSubview(imageScrollView)
        addSubview(shareButton)
        addSubview(saveButton)
        addSubview(likeButton)
        addSubview(infoButton)
    }
    
    @objc func shareButtonTapped() {
        delegate?.share()
    }
    @objc func saveButtonTapped() {
        delegate?.save()
    }
    @objc func likeButtonTapped() {
        delegate?.like()
    }
    @objc func infoButtonTapped() {
        delegate?.like()
        
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            
            imageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: topAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            shareButton.heightAnchor.constraint(equalToConstant: 55),
            shareButton.widthAnchor.constraint(equalToConstant: 55),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -120),
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            saveButton.heightAnchor.constraint(equalToConstant: 55),
            saveButton.widthAnchor.constraint(equalToConstant: 55),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -40),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            likeButton.heightAnchor.constraint(equalToConstant: 55),
            likeButton.widthAnchor.constraint(equalToConstant: 55),
            likeButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 40),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            infoButton.heightAnchor.constraint(equalToConstant: 55),
            infoButton.widthAnchor.constraint(equalToConstant: 55),
            infoButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 120),
            infoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
}


