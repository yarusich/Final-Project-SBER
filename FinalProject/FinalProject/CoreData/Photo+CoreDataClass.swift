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
    
    convenience init(context: NSManagedObjectContext, with photoModel: PhotoDTO) {
        self.init(context: context)
        self.id = photoModel.id
        self.width = photoModel.width
        self.height = photoModel.height
        self.descript = photoModel.descript
        self.author = photoModel.author
        self.url = photoModel.url
    }
}


