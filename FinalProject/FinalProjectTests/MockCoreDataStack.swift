//
//  MockCoreDataStack.swift
//  FinalProjectTests
//
//  Created by Антон Сафронов on 30.07.2021.
//

//import Foundation
//import CoreData
//
//class MockCoreDataStack: CoreDataStackProtocol {
//
//    var mainContext: NSManagedObjectContext
//    var backgroundContext: NSManagedObjectContext
//
//    private var coordinator: NSPersistentStoreCoordinator
//
//    init() {
//        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
//        let description = NSPersistentStoreDescription()
//        description.type = NSInMemoryStoreType
//        description.shouldAddStoreAsynchronously = false
//
//        coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
//        coordinator.addPersistentStore(with: description, completionHandler: { _, error in
//            guard error == nil else {
//                fatalError("fatal error")
//            }
//        })
//
//        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        self.mainContext.persistentStoreCoordinator = coordinator
//
//        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        self.backgroundContext.persistentStoreCoordinator = coordinator
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(contextDidChange(notification:)),
//                                               name: Notification.Name.NSManagedObjectContextDidSave,
//                                               object: self.backgroundContext)
//    }
//
//    func deleteMaps() {
//
//    }
//
//}
//
//private extension MockCoreDataStack {
//    @objc func contextDidChange(notification: Notification) {
//        coordinator.performAndWait {
//            mainContext.performAndWait {
//                mainContext.mergeChanges(fromContextDidSave: notification)
//            }
//        }
//    }
//}
