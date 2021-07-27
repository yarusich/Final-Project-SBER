//
//  BottomInfoListViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 27.07.2021.
//

import UIKit

final class BottomInfoListViewController: UIViewController {
    
    private let photo: PhotoDTO
    
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
    
//    private lazy var infoCloseButton: UIButton = {
//        let btm = UIButton(type: .system)
//        btm.setTitle("close", for: .normal)
//        btm.setTitleColor(.black, for: .normal)
//        btm.backgroundColor = .orange
//        btm.layer.cornerRadius = 15
//        btm.addTarget(self, action: #selector(infoCloseButtonTapped), for: .touchUpInside)
//        btm.translatesAutoresizingMaskIntoConstraints = false
//        return btm
//    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get Started"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
//    MARK: СТАК
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [infoHeadLabel, authorHeadLabel, authorTextLabel, dimensionHeadLabel, dimensionTextLabel, descriptionsHeadLabel, descriptionsTextLabel])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    init(photo: PhotoDTO) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)

        setupPanGesture()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
        
        authorTextLabel.text = photo.author
        dimensionTextLabel.text = "\(photo.height) x \(photo.width)"
        descriptionsTextLabel.text = photo.descript
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    func setupView() {
        view.backgroundColor = .clear
        
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])

        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)

        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    func setupPanGesture() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        print("Pan gesture y offset: \(translation.y)")
        
        
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        
        let newHeight = currentContainerHeight - translation.y
        
        
        switch gesture.state {
        case .changed:
            
            if newHeight < maximumContainerHeight {
                
                containerViewHeightConstraint?.constant = newHeight
                
                view.layoutIfNeeded()
            }
        case .ended:

            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            
            self.containerViewHeightConstraint?.constant = height
            
            self.view.layoutIfNeeded()
        }
        
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            
            self.dismiss(animated: false)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            
            self.view.layoutIfNeeded()
        }
    }
}


