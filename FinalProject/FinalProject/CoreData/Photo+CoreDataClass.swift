//
//  Photo+CoreDataClass.swift
//  FinalProject
//
//  Created by Антон Сафронов on 23.07.2021.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {

}

//MARK: сохранение штуки
//func cards(with predicate: NSPredicate) -> [CardDTO] {
//        let context = stack.mainContext
//        var result = [CardDTO]()
//
//        let request = NSFetchRequest<Card>(entityName: "Card")
//        request.predicate = predicate
//        context.performAndWait {
//            guard let cards = try? request.execute() else { return }
//            result = cards.map { CardDTO(with: $0) }
//        }
//        return result
//    }
//}
