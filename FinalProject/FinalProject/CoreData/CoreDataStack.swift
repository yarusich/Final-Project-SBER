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
    
    private let coordinator: NSPersistentStoreCoordinator
    
    private let objectModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "FinalProject", withExtension: "momd") else {
            fatalError("CoreData MOMD is nil")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("CoreData MOMD is nil")
        }
        return model
    }()
    
    
    
    init() {
        
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            fatalError("Documents is nil")
        }
        let url = URL(fileURLWithPath: documentsPath).appendingPathComponent("FinalProject.sqlite")
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
        mainContext.performAndWait {
            let photos = try? fetchRequest.execute()
            photos?.forEach {
                mainContext.delete($0)
            }
            try? mainContext.save()
        }
    }
    
    func delete(photos: [Photo]?) {
        guard let photos = photos else { return }
        
        mainContext.performAndWait {
            photos.forEach {
                if let photo = try? fetchRequest(for: $0).execute().first {
                    mainContext.delete(photo)
                }
            }
            try? mainContext.save()
        }
    }
    
    private func fetchRequest(for photo: Photo) -> NSFetchRequest<Photo> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        request.predicate = .init(format: "id == %@", photo.id)
        return request
    }
}


