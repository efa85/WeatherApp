//
//  CoreDataStackManager.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 31/12/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import CoreData

class CoreDataStackManager {
    
    let modelName: String
    let storeName: String
    
    /**
    @param modelName the name of the model with .momd extension. Example: "MyModel.momd"
    @param storeName the name of the sqlite store. Example: "MyStore.sqlite"
    */
    init(modelName: String, storeName: String) {
        self.modelName = modelName
        self.storeName = storeName
    }
    
    private(set) lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL: self.modelUrl)!
    }()
    
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeUrl, options: nil, error: nil)
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var mainQueueContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return context
    }()
    
    private(set) lazy var storeUrl: NSURL = {
        // TODO in documents?
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let documentsUrl = NSURL(fileURLWithPath: documentsPath)!
        return documentsUrl.URLByAppendingPathComponent(self.storeName)
    }()
    
    private(set) lazy var modelUrl: NSURL = {
        return NSBundle.mainBundle().URLForResource(self.modelName, withExtension: nil)!
    }()
}
