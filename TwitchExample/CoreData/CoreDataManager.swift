//
//  CoreDataManager.swift
//  Practice
//
//  Created by André Assis on 15/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    func addRemoveFavorite(_ gameId: Int) -> CoreDataGame? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        
        let predicate = NSPredicate(format: "gameId=%d", gameId)
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            
            if result.count > 0 {
                for item in result {
                    managedObjectContext.delete(item as! NSManagedObject)
                }
            } else {
                return addFavoriteGame(gameId)
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func removeFavoriteGame(_ gameId: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        
        let predicate = NSPredicate(format: "gameId=%d", gameId)
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            
            for item in result {
                managedObjectContext.delete(item as! NSManagedObject)
            }
        } catch {
            print(error)
        }
    }
    
    func addFavoriteGame(_ gameId: Int) -> CoreDataGame {
        
        let item: CoreDataGame = NSEntityDescription.insertNewObject(forEntityName: "FavoriteGame", into: managedObjectContext) as! CoreDataGame
        
        item.gameId = Int64(gameId)
        
        saveContext()
        
        return item
    }
    
    func isGameFavorite(_ gameId: Int) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        
        let predicate = NSPredicate(format: "gameId=%d", gameId)
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            
            if result.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
        }
        
        return false
        
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "PracticeApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("PracticeApp_v0.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "FRCoreDataError", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}
