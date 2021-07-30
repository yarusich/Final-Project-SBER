//
//  UserDefaultsService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 28.07.2021.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func addCurrentQuery(query: String)
    func getCurrentQuery() -> String
    func clearCurrentQuery()
}

final class UserDefaultsService {
    private let key = "Query"
    private let userDefault = UserDefaults.standard
}

extension UserDefaultsService: UserDefaultsServiceProtocol {
    
    func addCurrentQuery(query: String) {
        userDefault.setValue(query, forKey: key)
    }

    func getCurrentQuery() -> String {
        guard let query = userDefault.string(forKey: key) else { return ""}
        return query
    }
    
    func clearCurrentQuery() {
        userDefault.removeObject(forKey: key)
    }
}

