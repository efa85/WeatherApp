//
//  CoreDataLocationStore.swift
//  WeatherApp
//x
//  Created by Emilio Fernandez on 22/12/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import CoreData

let nameKey = "name"
let latitudeKey = "latitude"
let longitudeKey = "longitude"

class CoreDataLocationStore: LocationStore {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchLocations() -> [Location] {
        let fetchRequest = NSFetchRequest(entityName: Location.entityName)

        if let result = context.executeFetchRequest(fetchRequest, error: nil) as? [Location] {
            return result
        }
        else {
            return []
        }
    }

    func addLocationWithName(name: String, latitude: String, longitude: String) {
        let location = NSEntityDescription.insertNewObjectForEntityForName(Location.entityName, inManagedObjectContext: context) as NSManagedObject
        location.setValue(name, forKey: nameKey)
        location.setValue(latitude, forKey: latitudeKey)
        location.setValue(longitude, forKey: longitudeKey)
        
        context.save(nil)
    }
    
    func deleteLocation(location: Location) {
        let fetchRequest = NSFetchRequest(entityName: Location.entityName)
        fetchRequest.predicate = NSPredicate(format:"%K = %@", nameKey, location.name)
        
        if let result = context.executeFetchRequest(fetchRequest, error: nil) as [NSManagedObject]? {
            if result.count == 1 {
                let object = result[0]
                context.deleteObject(object)
            }
        }
        
        context.save(nil)
    }
    
//    struct LocationImpl: Location {
//        let name : String
//        let latitude : String
//        let longitude : String
//    }
    
}