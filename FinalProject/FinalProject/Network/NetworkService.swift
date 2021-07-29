//
//  NetworkService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 13.07.2021.
//

import UIKit

typealias GetPhotosAPIResponse = Result<GetPhotosResponse, NetworkServiceError>

protocol PhotoNetworkServiceProtocol {
    func searchPhotos(currentPage page: String, searching query: String, completion: @escaping (GetPhotosAPIResponse) -> Void)
//    func getRandomPhotos(current page: String, complition: @escaping (GetPhotosAPIResponse) -> Void)
    func loadPhoto(imageUrl: String, completion: @escaping (Data?) -> Void)
}

final class NetworkService {
    let timeoutInterval: Double = 30
    let perPage = "10"
    let httpMethod = "GET"
    let sessionConfig = URLSessionConfiguration.default
    
    
    private let decoder = JSONDecoder()

    private let session = URLSession.shared
    
    deinit {
        print("deinit NetworkService")
    }
}

extension NetworkService: PhotoNetworkServiceProtocol {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
//    MARK: SEARCH PHOTOS
    func searchPhotos(currentPage page: String, searching query: String, completion: @escaping (GetPhotosAPIResponse) -> Void) {
//        MARK: Сконфигурировали запрос
        var components = URLComponents(string: NetworkConstants.baseURLString)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: NetworkConstants.accessKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "per_page", value: perPage)
        ]
        guard let url = components?.url else { completion(.failure(.buildingURL)); return }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
  
//        MARK: HANDLER
        let handler: CompletionHandler = { data, resp, error in
            do {
                let data = try self.httpResponse(data: data, response: resp)
                let objects = try self.decoder.decode(GetPhotosResponse.self, from: data)
                completion(.success(objects))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }
        
//        MARK: CALL
        let dataTask = session.dataTask(with: request, completionHandler: handler)
        dataTask.resume()
    
    }
//  MARK: LOAD PHOTO
    func loadPhoto(imageUrl: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: imageUrl) else { completion(nil); return }

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)

//        MARK: PHOTO HANDLER
        let handler: CompletionHandler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                completion(data)
            } catch {
                completion(nil)
            }
        }

//        MARK: PHOTO CALL
        let dataTask = session.dataTask(with: request, completionHandler: handler)
        dataTask.resume()
    }

    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data else {
            throw NetworkServiceError.network
        }
        return data
    }
}


    





//
//    func searchPhotos<T: Decodable>(currentPage page: String, searching query: String, completion: @escaping (Result<T, NetworkServiceError>) -> Void) {
//        //        MARK: Сконфигурировали запрос
//        var components = URLComponents(string: NetworkConstants.baseURLString)
//        components?.queryItems = [
//            URLQueryItem(name: "client_id", value: NetworkConstants.accessKey),
//            URLQueryItem(name: "query", value: query),
//            URLQueryItem(name: "page", value: page),
//            URLQueryItem(name: "per_page", value: perPage)
//        ]
//        guard let url = components?.url else { completion(.failure(.buildingURL)); return }
//
//        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
//        request.httpMethod = httpMethod
////        var objects =
//        //        MARK: HANDLER
//        let handler: CompletionHandler = { data, resp, error in
//            if error != nil { return completion(.failure(NetworkServiceError.network))}
//            guard let data = data else { print("нет даты"); return }
//            do {
////                let data = try self.httpResponse(data: data, response: resp)
//                let objects = try self.decoder.decode(T.self, from: data)
//                print(2)
//                completion(.success(objects))
//            } catch {
//                print(3)
//                completion(.failure(.unknown))
////                completion(.success(objects))
//
//            }
//        }
//
//        //        MARK: CALL
//        let dataTask = session.dataTask(with: request, completionHandler: handler)
//        dataTask.resume()
//    }
//
//    //  MARK: LOAD PHOTO
//    func loadPhoto(imageUrl: String, completion: @escaping (Data?) -> Void) {
//        guard let url = URL(string: imageUrl) else { completion(nil); return }
//
//        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
//
//        //        MARK: PHOTO HANDLER
//        let handler: CompletionHandler = { rawData, response, taskError in
//            do {
//                let data = try self.httpResponse(data: rawData, response: response)
//                completion(data)
//            } catch {
//                completion(nil)
//            }
//        }
//
//        //        MARK: PHOTO CALL
//        let dataTask = session.dataTask(with: request, completionHandler: handler)
//        dataTask.resume()
//    }
//
//    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200..<300).contains(httpResponse.statusCode),
//              let data = data else {
//            throw NetworkServiceError.network
//        }
//        return data
//    }
//}
