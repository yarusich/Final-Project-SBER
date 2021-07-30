//
//  PhotoCellView.swift
//  FinalProject
//
//  Created by Антон Сафронов on 08.07.2021.
//

import UIKit

final class PhotoCellView: UICollectionViewCell {
    
    static let id = String(describing: self)
    private let networkService = NetworkService()
    private lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: .init(x: contentView.bounds.origin.x, y: contentView.bounds.origin.y, width: contentView.bounds.width, height: contentView.bounds.height))
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.layer.borderWidth = 4
                self.contentView.layer.borderColor = UIColor.orange.cgColor
            } else {
                self.contentView.layer.borderWidth = 0
            }
        }
    }

}

extension PhotoCellView {
    func configure(with model: PhotoDTO, _ image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
