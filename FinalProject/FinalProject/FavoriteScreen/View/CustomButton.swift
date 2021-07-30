//
//  CustomButton.swift
//  FinalProject
//
//  Created by Антон Сафронов on 30.07.2021.
//

import UIKit

class CustomButton: UIButton {
    
    init(name: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: name), for: .normal)
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 15
        self.alpha = 0.85
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
