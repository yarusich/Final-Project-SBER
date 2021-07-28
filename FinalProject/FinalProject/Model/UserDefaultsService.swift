//
//  UserDefaultsService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 28.07.2021.
//

import Foundation

struct KeysDefault {
    static let key = "Query"
}

protocol UserDefaultsServiceProtocol {
    func addCurrentQuery(query: String)
    func getCurrentQuery() -> String
}

final class UserDefaultsService {
    private let userDefault = UserDefaults.standard
}

extension UserDefaultsService: UserDefaultsServiceProtocol {
    func addCurrentQuery(query: String) {
        userDefault.setValue(query, forKey: KeysDefault.key)
    }

    func getCurrentQuery() -> String {
        guard let query = userDefault.string(forKey: KeysDefault.key) else { return ""}
        return query
    }
}

