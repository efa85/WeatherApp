//
//  AddLocationViewModel.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 07/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

//import Foundation



class AddLocationViewModel {
    
    private let locationStore: LocationStore
    
    init(locationStore: LocationStore) {
        self.locationStore = locationStore
    }
    
    var name: String?
    
    var coordinate: (Double,Double)?
    
    var isInputValid: Bool {
        get {
            return name != nil
                && countElements(name!) > 2
                && coordinate != nil
        }
    }
    
    enum Result {
        case Success
        case Error
    }
    
    func addLocation() -> Result {
        if let name = name {
            if let coordinate = coordinate {
                var latitude = "\(coordinate.0)"
                var longitude = "\(coordinate.1)"
                locationStore.addLocationWithName(name, latitude: latitude, longitude: longitude)
                
                return .Success
            }
        }

        return .Error
    }
    
}
