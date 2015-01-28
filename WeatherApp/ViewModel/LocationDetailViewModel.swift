//
//  LocationDetailViewModel.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 15/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import Foundation

class LocationDetailViewModel {
    
    private let location: Location
    private let weatherResponse: WeatherResponse
    
    init(location: Location, weatherResponse: WeatherResponse) {
        self.location = location
        self.weatherResponse = weatherResponse
    }
    
    // TODO Proper name? locationName or title? Should the i18n be handled in the view or view model?
    var title: String {
        get {
            return location.name
        }
    }
    
    var coordinate: (Double,Double) {
        get {
            let latitude = (location.latitude as NSString).doubleValue
            let longitude = (location.longitude as NSString).doubleValue
            return (latitude, longitude)
        }
    }
    
    var temperature: String {
        get {
            return weatherResponse.currentWeather.temperature
        }
    }
    
    var description: String {
        get {
            return weatherResponse.currentWeather.description
        }
    }
    
    var sunrise: String {
        get {
            return weatherResponse.astronomy.sunrise
        }
    }
    
    var sunset: String {
        get {
            return weatherResponse.astronomy.sunset
        }
    }
    
}
