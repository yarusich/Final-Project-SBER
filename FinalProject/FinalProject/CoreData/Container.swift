//
//  Container.swift
//  FinalProject
//
//  Created by Антон Сафронов on 23.07.2021.
//

import Foundation

final class Container{
    static let shared = Container()
    private init() { }
    
    lazy var coreDataStack = CoreDataStack()
}
