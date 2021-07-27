//
//  BottomSheetContainerViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 25.07.2021.
//


import UIKit

open class BottomSheetContainerViewController<Content: UIViewController, BottomSheet: UIViewController> : UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Initialization
    init(contentViewController: Content,
                bottomSheetViewController: BottomSheet,
                bottomSheetConfiguration: BottomSheetConfiguration) {
        
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        self.bottomSheetConfiguration = bottomSheetConfiguration
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Configuration
    struct BottomSheetConfiguration {
        let height: CGFloat
        let initialOffset: CGFloat
    }
    private let bottomSheetConfiguration: BottomSheetConfiguration
    
    
    //    MARK: - State
    enum BottomSheetState {
        case initial
        case full
    }
    var state: BottomSheetState = .initial
    
    
    // MARK: - Children
    let contentViewController: Content
    let bottomSheetViewController: BottomSheet
    
    
    lazy var panGesture: UIPanGestureRecognizer = {
       let p = UIPanGestureRecognizer()
        p.delegate = self
        p.addTarget(self, action: #selector(handlePan(_:)))
        return p
    }()
    
    private var topConstraint = NSLayoutConstraint()
    
    //    MARK: - UIPanGestureRecognizer Delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setupUI() {
        self.addChild(contentViewController)
        self.addChild(bottomSheetViewController)
        
        self.view.addSubview(contentViewController.view)
        self.view.addSubview(bottomSheetViewController.view)
        
        bottomSheetViewController.view.addGestureRecognizer(panGesture)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentViewController.didMove(toParent: self)
        
        topConstraint = bottomSheetViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSheetConfiguration.initialOffset)
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.heightAnchor.constraint(equalToConstant: bottomSheetConfiguration.height),
            bottomSheetViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomSheetViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topConstraint
        ])
        
        bottomSheetViewController.didMove(toParent: self)
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSheetViewController.view)
        let velocity = sender.velocity(in: bottomSheetViewController.view)
        
        let yTranslationMagnitude = translation.y.magnitude
        
        switch sender.state {
        case .began, .changed:
            if self.state == .full {
                guard translation.y > 0 else { return }
                topConstraint.constant = -(bottomSheetConfiguration.height - yTranslationMagnitude)
                self.view.layoutIfNeeded()
            } else {
                let newConstant = -(bottomSheetConfiguration.height + yTranslationMagnitude)
                guard translation.y < 0 else { return }
                guard newConstant.magnitude < bottomSheetConfiguration.height else {
                    self.showBottomSheet()
                    return
                }
                topConstraint.constant = newConstant
                self.view.layoutIfNeeded()
            }
        case .ended:
            if self.state == .full {
                if yTranslationMagnitude >= bottomSheetConfiguration.height / 2 || velocity.y > 1000 {
                    self.hideBottomSheet()
                } else {
                    self.showBottomSheet()
                }
            } else {
                if yTranslationMagnitude >= bottomSheetConfiguration.height / 2 || velocity.y < -1000 {
                    self.showBottomSheet()
                } else {
                    self.hideBottomSheet()
                }
            }
        case .failed:
            if self.state == .full {
                self.showBottomSheet()
            } else {
                self.hideBottomSheet()
            }
        default: break
        }
    }
    
    func showBottomSheet(animated: Bool = true) {
        topConstraint.constant = -bottomSheetConfiguration.height
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.state = .full
            })
        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
    }
    
    func hideBottomSheet(animated: Bool = true) {
        topConstraint.constant = -bottomSheetConfiguration.initialOffset
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseOut],
                           animations: {
                            self.view.layoutIfNeeded()
                           }, completion: { _ in
                            self.state = .initial
                           })
        } else {
            self.view.layoutIfNeeded()
            self.state = .initial
        }
    }
    
    
}

