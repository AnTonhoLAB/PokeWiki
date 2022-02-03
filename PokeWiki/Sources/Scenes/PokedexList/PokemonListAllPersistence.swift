//
//  PersistenceManager.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 03/02/22.
//

import Foundation
import CoreData
import RxSwift

class PersistenceManager {
    
    
//    protocol PokemonListAllServiceProtocol {
//        func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse>
//    }
    
    func fetchList() -> Single<PokemonListResponse> {
        
    }
}


final class PersistentContainer: NSPersistentContainer {

    static let shared = PersistentContainer(name: "PokeWiki", managedObjectModel: .sharedModel)

//    private var persistentHistoryObserver: PersistentHistoryObserver?
    
    private override init(name: String, managedObjectModel: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: managedObjectModel)
        
        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print(storeDescription)
        })

        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }

    func setup() {

        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }

    /// A convenience method for creating background contexts that specify the app as their transaction author.
    /// It's best practice to perform heavy lifting on a background context.
    ///
    /// - Returns: The background context configured with a name and transaction author.
    override func newBackgroundContext() -> NSManagedObjectContext {
        let context = super.newBackgroundContext()
        context.name = "background_context"
        context.transactionAuthor = "main_app_background_context"
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}


extension NSManagedObjectModel {
    /// We use this static shared model to prevent errors like:
    /// `Failed to find a unique match for an NSEntityDescription to a managed object subclass`
    ///
    /// This error likely occurs when running tests with an in-memory store while the regular app launch loads a file backed store.
    static let sharedModel: NSManagedObjectModel = {
        let url = Bundle(for: PersistentContainer.self).url(forResource: "PokeWiki", withExtension: "momd")!
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Managed object model could not be created.")
        }
        return managedObjectModel
    }()
}
