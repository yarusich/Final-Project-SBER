//
//  PhotoModel.swift
//  FinalProject
//
//  Created by Антон Сафронов on 08.07.2021.
//

// MARK: Надо убрать отсюда uikit, да?
import UIKit

struct Photo {
    let name: String
    private(set) var image: UIImage = UIImage()
    init(_ name: String) {
        self.image = UIImage(named: name) ?? UIImage()
        self.name = name
    }
//    var setImage: UIImage {
//       image = UIImage(named: name) ?? UIImage()
//    }
}

class PhotoModel {
//    static let photos: [UIImage] = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8", "cat9", "cat10", "cat11", "cat12", "cat13", "cat14", ].map { image in
//        UIImage(named: "\(image)") ?? UIImage()
//    }
    
//    weak var delegate: PhotoModelDelegate?
    var delegate: PhotoModelDelegate?
    
    lazy var photos: [Photo] = names.map { Photo($0) }
    
    let defoltPhotos: [UIImage] = ["cat2", "cat4", "cat5", "cat6", "cat7", "cat8", "cat10", "cat11", "cat12", "cat14", ].map { image in
        UIImage(named: "\(image)") ?? UIImage()
    }
    var searhingPhotos = [Photo]()
    
    private let names: [String] = ["cat2", "cat4", "cat5", "cat6", "cat7", "cat8", "cat10", "cat11", "cat12", "cat14"]

//    MARK: надо будет хранить это
    private var oldRequest = [String]()
    

    
    func getPhotos(_ request: String) -> [Photo] {
//        вынести в отдельную фун
        oldRequest.append(request)
        
        let outPhotos = photos.filter({ $0.name.lowercased() == request.lowercased() })
    
        searhingPhotos = outPhotos
        return outPhotos
            
        }
        
    }

