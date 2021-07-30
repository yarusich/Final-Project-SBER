//
//  NetworkService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 13.07.2021.
//

import UIKit

protocol PhotoNetworkServiceProtocol {
    func searchPhotos(currentPage page: String, searching query: String, completion: @escaping (Result<GetPhotosResponse, NetworkServiceError>) -> Void)
//    func getRandomPhotos(current page: String, complition: @escaping (GetPhotosAPIResponse) -> Void)
    func loadPhoto(imageUrl: String, completion: @escaping (Result<UIImage, NetworkServiceError>) -> Void)
}

final class NetworkService {
    let perPage = "5"
    let httpMethod = "GET"
    private let imageCacheService: ImageCacheService = .shared
    private let decoder = JSONDecoder()

    private let session = URLSession.shared
    
    deinit {
        print("deinit NetworkService")
    }
}

extension NetworkService: PhotoNetworkServiceProtocol {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
//    MARK: SEARCH PHOTOS
    func searchPhotos(currentPage page: String, searching query: String, completion: @escaping (Result<GetPhotosResponse, NetworkServiceError>) -> Void) {
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
        session.dataTask(with: request) { rawData, response, error in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let objects = try self.decoder.decode(GetPhotosResponse.self, from: data)
                completion(.success(objects))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }

        .resume()
    
    }
//  MARK: LOAD PHOTO
    func loadPhoto(imageUrl: String, completion: @escaping (Result<UIImage, NetworkServiceError>) -> Void) {
        guard let url = URL(string: imageUrl) else { return }
        var resultImage = UIImage()
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)

//        MARK: PHOTO HANDLER

//    MARK: Cюда вставить кэш
        if let cachedImage = imageCacheService.getImage(key: url.absoluteString) {
            resultImage = cachedImage
        } else {
            
        session.dataTask(with: request) { (rawData: Data?, response: URLResponse?, error: Error?) in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                guard let image = UIImage(data: data) else { return }
                self.imageCacheService.setImage(image: image, key: url.absoluteString)
                completion(.success(image))
            } catch  let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }

//        MARK: PHOTO CALL

            .resume()
        }
        completion(.success(resultImage))
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

