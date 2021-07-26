//
//  BottomSheetContainerViewController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 25.07.2021.
//


import UIKit

open class BottomSheetContainerViewController<Content: UIViewController, BottomSheet: UIViewController> : UIViewController {
    
    // MARK: - Initialization
    public init(contentViewController: Content,
                bottomSheetViewController: BottomSheet) {
        
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Children
    let contentViewController: Content
    let bottomSheetViewController: BottomSheet
}

