//
//  NetworkService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 13.07.2021.
//

import UIKit

final class NetworkService {

    
    let session = URLSession.shared
    
    func some() {
        guard let url = URL(string: NetworkConstants.baseURLString) else {
            fatalError()
        }
        let request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy, //кэширование данных
                                 timeoutInterval: 120) // что это
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else { return }
            
            guard let data = data else { return }
            
//            if let result = String(data: data, encoding: .utf8) {
//                print(result)
//            }
        }
        task.resume()
    }

//let product: Product = try! JSONDecoder().decode(Product.self, from: data)
    
    
}

//  MARK: Курсор
struct Cursor {
    let page: Int                       //текущая страница
    let perPage: Int                    //элементов на странице
//    let parameters: [String: Any]?      //что-то
}

//  MARK: Размеры изображений
enum ImageSizeUrls {
    case raw
    case full
    case regular
    case small
    case thumb
}

//  MARK: Парсим
//struct
