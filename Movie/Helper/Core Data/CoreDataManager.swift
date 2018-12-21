//
//  CoreDataManager.swift
//  Movie
//
//  Created by mac-0002 on 20/12/18.
//  Copyright © 2018 mac-0002. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    private init() {}
    
    private static var coreDataManager:CoreDataManager = {
        let coreDataManager = CoreDataManager()
        return coreDataManager
    }()
    
    static var shared:CoreDataManager = {
        return coreDataManager
    }()
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy private(set) var mainManagedObjectContext:NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}

extension CoreDataManager {
    
    func save() {
        mainManagedObjectContext.saveChanges()
    }
}



