////
////  TempClass.swift
////  FinalProject
////
////  Created by Антон Сафронов on 29.07.2021.
////
//
//import UIKit
//
//var imageCache = NSCache<AnyObject, AnyObject>()
//extension UIImageView {
//    func loadImage(imageURL: String) {
//        if let image = imageCache.object(forKey: imageURL as NSString) as? UIImage {
//            self.image = image
//            return
//        }
//        DispatchQueue.global().async { [weak self] in
//            guard let self = self else { return }
//            guard let url = URL(string: imageURL), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
//            imageCache.setObject(image, forKey: imageURL as NSString)
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//    }
//}
//
//
//func createActivity(with vc: UIViewController, message: String) {
//    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
//                                  style: .default,
//                                  handler: { _ in NSLog("The \"OK\" alert occured.")}))
//    vc.present(alert, animated: true, completion: nil)
//}
//
//    enum NetworkError: Error {
//        case network
//        case url
//        case networkError(underlyingError: Error)
//    }
//
//
//

