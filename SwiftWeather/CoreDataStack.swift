//
//  CoreDataStack.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 19/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "WeatherModel")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
        
    private init() { }
}

extension CoreDataStack {
    // Add a convenience method to commit changes to the store.
    func save() {
        // Verify that the context has uncommitted changes.
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            // Attempt to save changes.
            try persistentContainer.viewContext.save()
        } catch {
            // Handle the error appropriately.
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func delete(item: SavedLocation) {
        persistentContainer.viewContext.delete(item)
        save()
    }
}
extension CoreDataStack {
    
    
    func getAllSavedLocations() -> [SavedLocation]? {
        let managedContext =
            self.persistentContainer.viewContext
        
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "SavedLocation")
        do {
            if let response = try managedContext.fetch(fetchRequest) as? [SavedLocation] {
                return response
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
}
