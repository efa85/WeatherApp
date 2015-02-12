//
//  CoreDataStackManager.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 31/12/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    let model: NSManagedObjectModel
    let storeType: StoreType
    
    enum StoreType {
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
    
    init(model: NSManagedObjectModel, storeType: StoreType) {
        self.model = model
        self.storeType = storeType
    }
    
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        persistentStoreCoordinator.addPersistentStoreWithType(self.storeType.persistentStoreType, configuration: nil, URL: self.storeUrl, options: nil, error: nil)
        
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var mainQueueContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return context
    }()
    
    private(set) lazy var storeUrl: NSURL? = {
        switch self.storeType {
        case .SQLite(let storeName):
            // TODO: in documents?
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let documentsUrl = NSURL(fileURLWithPath: documentsPath)!
            return documentsUrl.URLByAppendingPathComponent(storeName)
        case .InMemory():
            return nil
        }
    }()
    
}

extension CoreDataStack {
    
    // TODO: make this a convenience initializer
    class func withModelName(modelName: String, storeType: StoreType, substitutionSwiftModuleName: String? = nil) -> CoreDataStack {
        let modelUrl = NSBundle.mainBundle().URLForResource(modelName, withExtension: nil)!
        let model = NSManagedObjectModel(contentsOfURL: modelUrl)!
        return CoreDataStack(
            model: substituteSwiftModuleNameIfNeededWithPrefix(substitutionSwiftModuleName, model: model),
            storeType: storeType
        )
    }
    
}

private extension CoreDataStack {
    
    class func substituteSwiftModuleNameIfNeededWithPrefix(prefix: String?, model: NSManagedObjectModel) -> NSManagedObjectModel {
        if let prefix = prefix {
            return modelByChangingEntitiyManagedObjectClassNameSwiftModuleName(prefix, originalModel: model)
        }
        else {
            return model
        }
    }
    
    class func modelByChangingEntitiyManagedObjectClassNameSwiftModuleName(moduleName: String, originalModel: NSManagedObjectModel) -> NSManagedObjectModel {
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
