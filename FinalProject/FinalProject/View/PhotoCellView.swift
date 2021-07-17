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
        iv.image = UIImage()
//        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
//    private lazy var imageViewConstraint: [NSLayoutConstraint] = {
//       return [
//        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//       ]
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
//        NSLayoutConstraint.activate(imageViewConstraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}

extension PhotoCellView {
    func configure(with model: GetPhotosDataResponse) {
//       MARK: получаем отсюда ссылку и качаем картинку
        loadPhotoData(str: model.urls.regular)
//        imageView.image = UIImage(named: "cat2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    
    private func loadPhotoData(str: String) {
        networkService.loadPhotoTrue(imageUrl: str) { data in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
//                    self.imageView.image = UIImage(named: "cat2")
                }
            }
        }
    }
}
