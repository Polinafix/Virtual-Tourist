//
//  CoreDataStack.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 15/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import CoreData

// MARK: - CoreDataStack

struct CoreDataStack {

    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
     lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy  var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    static func saveContext(_ managedContext: NSManagedObjectContext) {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    mutating func saveContext (managedContext: NSManagedObjectContext) {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

    static func autoSave(_ delayInSeconds : Int,_ context: NSManagedObjectContext ) {
        if delayInSeconds > 0 {
           saveContext(context)
            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)            
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.autoSave(delayInSeconds, context)
            }
        }
    }
}


