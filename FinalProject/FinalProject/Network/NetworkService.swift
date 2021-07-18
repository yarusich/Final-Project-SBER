//
//  NetworkService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 13.07.2021.
//

import UIKit

final class NetworkService {
    
    private let decoder = JSONDecoder()

    private let session = URLSession.shared
    
    deinit {
        print("deinit NetworkService")
    }
}

extension NetworkService: PhotoNetworkServiceProtocol {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
//    MARK: SEARCH PHOTOS
    func searchPhotos(currentPage page: String, searching query: String, complition: @escaping (GetPhotosAPIResponse) -> Void) {
        
//        MARK: Курсор и запрос, принимать из вне. Курсор видимо переписать, используя объект Cursor
//        let query = "cats"
//        let page = String(cursor)
        let perPage = String(3)
//        MARK: Сконфигурировали запрос
        var components = URLComponents(string: NetworkConstants.baseURLString)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: NetworkConstants.accessKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: page),
            URLQueryItem(name: "per_page", value: perPage)
        ]
        guard let url = components?.url else { complition(.failure(.buildingURL)); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//        MARK: HANDLER
        let handler: CompletionHandler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = try self.decoder.decode(GetPhotosResponse.self, from: data)
                complition(.success(response))
            } catch let error as NetworkServiceError {
                complition(.failure(error))
            } catch {
                complition(.failure(.unknown))
            }
        }
//        MARK: CALL
        let dataTask = session.dataTask(with: request, completionHandler: handler)
        dataTask.resume()
    }
    
//  MARK: LOAD PHOTO
    func loadPhoto(imageUrl: String, complition: @escaping (Data?) -> Void) {
        guard let url = URL(string: imageUrl) else { complition(nil); return }
        
//        MARK: КЭШИРОВАНИЕ!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
//        MARK: PHOTO HANDLER
        let handler: CompletionHandler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                complition(data)
            } catch {
                complition(nil)
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


