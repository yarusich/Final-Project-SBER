////
////  UserDefaultsServiceOld.swift
////  FinalProject
////
////  Created by Антон Сафронов on 18.07.2021.
////
//
//import UIKit
//
//
//
//
//
//
//
//protocol UserDefaultsServiceProtocol {
//    func addCurrentQuery(query: String)
//    func getCurrentQuery() -> String
//    func getAllQuerys() -> [String]
//}
//final class UserDefaultsService {
//
//    private let queryDefaultsService = QueryDefaultsService()
//
//    private let queryDefaults = QueryDefaults()
//
//    init() {
//        queryDefaultsService.save(object: QueryDefaults(), for: KeysDefault.key)
//    }
//
//}
//
//extension UserDefaultsService: UserDefaultsServiceProtocol {
//    func addCurrentQuery(query: String) {
//        queryDefaults.currentQuery = query
//        queryDefaults.querys.append(query)
//        queryDefaultsService.save(object: queryDefaults, for: KeysDefault.key)
//
//    }
//
//    func getCurrentQuery() -> String {
//        guard let queryObj: QueryDefaults = queryDefaultsService.object(for: KeysDefault.key) else { return "Запрос по-умолчанию" }
//        return queryObj.currentQuery
//    }
//
//    func getAllQuerys() -> [String] {
//        guard let queryObj: QueryDefaults = queryDefaultsService.object(for: KeysDefault.key) else { return [String]() }
//        return queryObj.querys
//    }
//
//
//}
//
