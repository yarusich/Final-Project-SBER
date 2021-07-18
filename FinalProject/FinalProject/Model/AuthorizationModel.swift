//
//  AuthorizationModel.swift
//  FinalProject
//
//  Created by Антон Сафронов on 18.07.2021.
//

import Foundation

final class AuthorizationModel {
    
    private var users = [String]()
    
    func checkUser(_ userName: String) -> Bool {
        for user in users {
            if user == userName {
                return false
            }
        }
        return true
    }
    
    func appendNewUser(_ userName: String) {
            users.append(userName)
    }
    
    
}
