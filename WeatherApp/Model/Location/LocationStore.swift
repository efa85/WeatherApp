//
//  LocationStore.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 24/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

protocol LocationStore {
    
    func fetchLocations() -> [Location]
    
    func addLocationWithName(name: String, latitude: String, longitude: String)
    
    func deleteLocation(location: Location)
    
}
