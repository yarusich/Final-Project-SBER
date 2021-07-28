//
//  Photo+CoreDataProperties.swift
//  FinalProject
//
//  Created by Антон Сафронов on 28.07.2021.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var author: String
    @NSManaged public var descript: String
    @NSManaged public var height: Int16
    @NSManaged public var id: String
    @NSManaged public var url: String
    @NSManaged public var width: Int16

}

extension Photo : Identifiable {

}
