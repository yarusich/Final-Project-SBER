//
//  UsersStorageService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 20.07.2021.
//

import Foundation

final class UsersStorageService {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(userDefaults: UserDefaults) {
        self.defaults = userDefaults
    }
    
    convenience init() {
        self.init(userDefaults: UserDefaults.standard)
    }
//    MARK: !!!
    func save<T: Encodable>(object: T, for key: String) {   //throws чтобы ловить ошибку
        guard let data = try? encoder.encode(object) else { return }
        defaults.setValue(data, forKey: key)
    }
    
    func object<T: Decodable>(for key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
