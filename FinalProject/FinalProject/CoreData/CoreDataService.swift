//
//  CoreDataService.swift
//  FinalProject
//
//  Created by Антон Сафронов on 28.07.2021.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func save(photos: [PhotoDTO])
    func delete(photos: [PhotoDTO]?)
}

protocol CoreDataSeriviceDelegate: AnyObject {
    func reloadData()
}

final class CoreDataService: NSObject {
    
    weak var delegate: CoreDataSeriviceDelegate?
    
    private let stack = Container.shared.coreDataStack
    
    lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        request.sortDescriptors = [.init(key: "id", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: stack.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
        
    
}

extension CoreDataService: CoreDataServiceProtocol {
    
    func save(photos: [PhotoDTO]) {
        let context = stack.mainContext
        context.performAndWait {
            photos.forEach {
                if let photo = try? self.fetchRequest(for: $0).execute().first {
                    photo.id = $0.id
                    photo.width = $0.width
                    photo.height = $0.height
                    photo.descript = $0.descript ?? ""
                    photo.author = $0.author
                    photo.url = $0.url
                } else {
                    let ph = Photo(context: context)
                    ph.id = $0.id
                    ph.width = $0.width
                    ph.height = $0.height
                    ph.descript = $0.descript ?? ""
                    ph.author = $0.author
                    ph.url = $0.url
                }
            }
            try? context.save()
        }
    }

    func delete(photos: [PhotoDTO]?) {
        guard let photos = photos else {
            return
        }
        let context = stack.mainContext
        context.performAndWait {
            photos.forEach {
                if let photo = try? self.fetchRequest(for: $0).execute().first {
                    context.delete(photo)
                }
            }
            try? context.save()
        }
    }
}

extension CoreDataService {
    private func fetchRequest(for photo: PhotoDTO) -> NSFetchRequest<Photo> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        request.predicate = .init(format: "id == %@", photo.id)
        return request
    }
}

fileprivate extension PhotoDTO {
    init(with MO: PhotoDTO) {
        self.id = MO.id
        self.width = MO.width
        self.height = MO.height
        self.descript = MO.descript
        self.author = MO.author
        self.url = MO.url
    }
}

extension CoreDataService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.reloadData()
    }
}
