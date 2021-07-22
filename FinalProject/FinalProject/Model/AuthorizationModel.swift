//
//  AuthorizationModel.swift
//  FinalProject
//
//  Created by Антон Сафронов on 18.07.2021.
//

import Foundation

final class AuthorizationModel {
    
//    private let userPorfiles = UsersProfiles()
//    private let usersStorageService = UsersStorageService()
    
    private let usersKey = "users"
    private let currentUserKey = "currentUser"
    private var users: [String]
    
    //    MARK: Подумать над этим местом
    init() {
        if let users = UserDefaults.standard.array(forKey: usersKey) as? [String] {
            self.users = users
            print(users)
        } else {
            self.users = [String]()
        }
    }
    
    func checkUser(_ userName: String) -> Bool {
        for user in users {
            if user == userName {
                return false
            }
        }
        return true
    }
    
    
    //    func checkUser(_ userName: String) throws -> OurResult<Bool, OurError> {
    //        guard let users =  UserDefaults.standard.array(forKey: "users") as? [String] else { return .error(OurError(errorMessage: "Массив не найден")) }
    //        for user in users {
    //            if user == userName {
    //                return .succeses(false)
    //            }
    //        }
    //        return .succeses(true)
    //    }
    
    func appendNewUser(_ userName: String) {
        users.append(userName)
        UserDefaults.standard.setValue(users, forKey: usersKey)
    }
    
    //    func appendNewUser(_ userName: String) -> Bool {
    //        guard var users =  UserDefaults.standard.array(forKey: "users") as? [String] else { return false }
    //        usersStorageService.save(object: UsersProfiles(), for: "users")
    //        let userss: UsersProfiles? = usersStorageService.object(for: "users")
    //        userss?.users.append(userName)
    //        users.append(userName)
    //        UserDefaults.setValue(users, forKey: "users")
    //        return true
    //    }
    
    func addCurrentUser(_ userName: String) {
        UserDefaults.standard.setValue(userName, forKey: currentUserKey)
    }
}
