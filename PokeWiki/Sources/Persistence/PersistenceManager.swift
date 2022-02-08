//
//  PersistenceManager.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 03/02/22.
//

import Foundation
import CoreData
import RxSwift

enum CoreDataError: Error {
    case couldNotCreateObject
    case couldNotFetchObject
    case couldNotDeleteObject
}

class PersistenceManager {
    
    func create<T: NSManagedObject>(_ object: T.Type) throws -> T {
        let modelName = String(describing: object)
        guard let object = NSEntityDescription.insertNewObject(forEntityName: modelName, into: PersistentContainer.shared.viewContext) as? T else {
            throw CoreDataError.couldNotCreateObject
        }
        return object
    }
       
    func fetch<T: NSManagedObject>(_ model: T.Type) throws -> [T] {
        let entityName = String(describing: model)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            
            let context = PersistentContainer.shared.viewContext
            guard let results = try context.fetch(request) as? [NSManagedObject],
            let uwnrapResults = results as? [T] else { throw CoreDataError.couldNotDeleteObject }
            return uwnrapResults
        } catch {
            throw CoreDataError.couldNotFetchObject
        }
    }
    
    func fetchSingle<T: NSManagedObject>(_ model: T.Type, id: Int) throws  -> T {
        
        let entityName = String(describing: model)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        do {
            let context = PersistentContainer.shared.viewContext
            guard let results = try context.fetch(request) as? [NSManagedObject],
            let result = results.first,
            let uwnrapResult = result as? T else { throw CoreDataError.couldNotFetchObject }
            
            return uwnrapResult
        } catch {
            throw CoreDataError.couldNotFetchObject
        }
    }
    
    func fetchSingle<T: NSManagedObject>(_ model: T.Type, name: String) throws  -> T {
        
        let entityName = String(describing: model)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let context = PersistentContainer.shared.viewContext
            guard let results = try context.fetch(request) as? [NSManagedObject],
            let result = results.first,
            let uwnrapResult = result as? T else { throw CoreDataError.couldNotDeleteObject }
            
            return uwnrapResult
        } catch {
            throw CoreDataError.couldNotFetchObject
        }
    }
       
    func save() throws {
        try PersistentContainer.shared.viewContext.save()
    }
    
    func delete<T: NSManagedObject>(_ model: T.Type, id: Int) throws {
        
        let entityName = String(describing: model)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        do {
            let context = PersistentContainer.shared.viewContext
            guard let results = try context.fetch(request) as? [NSManagedObject] else { throw CoreDataError.couldNotDeleteObject }
            for result in results  {
                context.delete(result)
            }
            try save()
         } catch {
             throw CoreDataError.couldNotDeleteObject
         }
     }
}
