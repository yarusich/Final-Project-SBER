//
//  CoreDataStack.swift
//  FinalProject
//
//  Created by Антон Сафронов on 23.07.2021.
//

import Foundation
import CoreData

final class CoreDataStack {
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    private let objectModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "CoreDataFRC", withExtension: "momd") else {
            fatalError("CoreData MOMD is nil")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("CoreData MOMD is nil")
        }
        return model
    }()
    
    private let coordinator: NSPersistentStoreCoordinator
    
    init() {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,
                                                                     .userDomainMask, true).first else {
            fatalError("Documents is nil")
        }
        let url = URL(fileURLWithPath: documentPath).appendingPathComponent("CoreDataFRC.sqlite")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
        } catch {
            fatalError()
        }
        
        self.coordinator = coordinator
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.persistentStoreCoordinator = coordinator
        
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.parent = self.mainContext
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        backgroundContext.performAndWait {
            let photos = try? fetchRequest.execute()
            photos?.forEach {
                backgroundContext.delete($0)
            }
            try? backgroundContext.save()
        }
    }
}

