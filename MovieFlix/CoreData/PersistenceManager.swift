//
//  PersistanceManager.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//

import Foundation
import CoreData

final class PersistenceManager {

    private init() {}
    static let shared = PersistenceManager()
    lazy var context = persistentContainer.viewContext
    var predicate: NSPredicate?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieFlixModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func save() {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
                print("Saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch<T: NSManagedObject> (_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch let err {
            print(err)
            return [T]()
        }
    }

    func fetchWithPredicate<T: NSManagedObject> (_ objectType: T.Type, key: String, with filter: String) -> [T] {

        predicate = NSPredicate(format: "\(key) == %@", filter)
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch let err {
            print(err)
            return [T]()
        }
    }

    func delete(_ objectType: NSManagedObject) {
        context.delete(objectType)
        save()
    }

    func deleteAllRecords(_ entityName: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error while trying to delete the entity: \(entityName)")
        }
    }

}
