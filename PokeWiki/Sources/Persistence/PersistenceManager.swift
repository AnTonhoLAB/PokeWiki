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
}

class PersistenceManager {
    
    func create<T: NSManagedObject>(_ object: T.Type) throws -> T {
        let modelName = String(describing: object)
        guard let object = NSEntityDescription.insertNewObject(forEntityName: modelName, into: PersistentContainer.shared.viewContext) as? T else {
            throw CoreDataError.couldNotCreateObject
        }
        return object
    }
       
    func fetch<T: NSManagedObject>(_ model: T.Type, predicate: NSPredicate? = nil, completion: @escaping (([T]) -> Void)) throws {
        let entityName = String(describing: model)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
           
        do {
            var ans = try PersistentContainer.shared.viewContext.fetch(request)
            if let predicate = predicate,
                let unfilteredAns = ans as? [NSManagedObject] {
                ans = unfilteredAns.filter { predicate.evaluate(with: $0) }
            }
               //swiftlint:disable:next force_cast
            completion(ans as! [T])
        } catch {
            throw CoreDataError.couldNotFetchObject
        }
    }
       
    func save() throws {
        try PersistentContainer.shared.viewContext.save()
    }
}


