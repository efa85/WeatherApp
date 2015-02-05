//
//  CoreDataStackManager.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 31/12/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    let modelName: String
    let type: Type
    let substitutionSwiftModuleName: String?
    
    enum Type {
        case SQLite(storeName: String)
        case InMemory
        
        var persistentStoreType: String {
            get {
                switch self {
                case .SQLite(_):
                    return NSSQLiteStoreType
                case .InMemory:
                    return NSInMemoryStoreType
                }
            }
        }
    }
    
    /**
    @param modelName the name of the model with .momd extension. Example: "MyModel.momd"
    @param storeName the name of the sqlite store. Example: "MyStore.sqlite"
    @param substitutionSwiftModuleName the substitution Swift module name to use in the entity's managedObjectClassName, or nil if we do not want any substitution
    */
    init(modelName: String, type: Type, substitutionSwiftModuleName: String? = nil) {
        self.modelName = modelName
        self.type = type
        self.substitutionSwiftModuleName = substitutionSwiftModuleName
    }
    
    private(set) lazy var model: NSManagedObjectModel = {
        let model = NSManagedObjectModel(contentsOfURL: self.modelUrl)!
        
        if let substitutionSwiftModuleName = self.substitutionSwiftModuleName {
            return self.modelByChangingEntitiyManagedObjectClassNameSwiftModuleName(substitutionSwiftModuleName, originalModel: model)
        }
        else {
            return model
        }
    }()
    
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        persistentStoreCoordinator.addPersistentStoreWithType(self.type.persistentStoreType, configuration: nil, URL: self.storeUrl, options: nil, error: nil)
        
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var mainQueueContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return context
    }()
    
    private(set) lazy var storeUrl: NSURL? = {
        switch self.type {
        case .SQLite(let storeName):
            // TODO in documents?
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsUrl = NSURL(fileURLWithPath: documentsPath)!
            return documentsUrl.URLByAppendingPathComponent(storeName)
        case .InMemory():
            return nil
        }
    }()
    
    private(set) lazy var modelUrl: NSURL = {
        return NSBundle.mainBundle().URLForResource(self.modelName, withExtension: nil)!
    }()
    
}

private extension CoreDataStack {
    func modelByChangingEntitiyManagedObjectClassNameSwiftModuleName(moduleName: String, originalModel: NSManagedObjectModel) -> NSManagedObjectModel {
        let model = NSManagedObjectModel(byMergingModels: [originalModel])!
        for entity in model.entities as [NSEntityDescription] {
            let originalManagedObjectClassName = entity.managedObjectClassName
            let components = originalManagedObjectClassName.componentsSeparatedByString(".")
            assert(components.count == 2, "managedObjectClassName should have the form ModuleName.ClassName")
            
            let newManagedObjectClassName = "\(moduleName).\(components[1])"
            
            entity.managedObjectClassName = newManagedObjectClassName
        }
        
        return model
    }
}
