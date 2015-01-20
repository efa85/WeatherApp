//
//  Location.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 31/12/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import CoreData

class Location : NSManagedObject {
    class var entityName: String {
        get {
            return "Location"
        }
    }
    
    @NSManaged var name: String
    @NSManaged var latitude: String
    @NSManaged var longitude: String
}