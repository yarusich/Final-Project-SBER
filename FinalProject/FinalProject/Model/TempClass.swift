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
final class HTTPHandler {
    let session = URLSession.shared

    func get(baseURL: String = "", endPoint: String = "", parametrs: [String: String] = [:], completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = parametrs.compactMap { URLQueryItem(name: $0, value: $1) }
        components?.path = endPoint
        guard let url = components?.url else { completion(.failure(.url)); return }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        task(with: request, completion: completion)
    }

    func task(with request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { (data, _, error) in
            let result: Result<Data, NetworkError>
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            switch (data, error) {
            case let (.some(data), .none):
                result = .success(data)
            case let (.none, .some(error)):
                result = .failure(NetworkError.networkError(underlyingError: error))
            case (.none, .none),
                 (.some, .some):
                result = .failure(NetworkError.network)
            }
        }
        task.resume()
    }
}
