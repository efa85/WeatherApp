//
//  LocationsViewModel.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 24/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import Foundation

class LocationsViewModel {
    
    private let locationsStore: LocationStore
    
    private let locationViewModelProvider: (location: Location) -> (LocationViewModel)
    
    init(locationsStore: LocationStore,
         locationViewModelProvider: (location: Location) -> (LocationViewModel)) {
        self.locationsStore = locationsStore
        self.locationViewModelProvider = locationViewModelProvider
    }
    
    var numberOfLocations: Int {
        get {
            return self.locationsStore.fetchLocations().count
        }
    }
    
    func locationViewModelForIndex(index: Int) -> LocationViewModel {
        let locations = locationsStore.fetchLocations()
        let location = locations[index]
        
        return locationViewModelProvider(location: location)
    }
    
    func deleteLocationAtIndex(index: Int) {
        let location = locationsStore.fetchLocations()[index]
        
        locationsStore.deleteLocation(location)
    }
    
}
