//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 24/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import Foundation

class LocationViewModel {
    
    private let location: Location
    
    private let weatherRetriever: WeatherRetriever
    
    init(location: Location, weatherRetriever: WeatherRetriever) {
        self.location = location
        self.weatherRetriever = weatherRetriever
    }
    
    var locationName: String {
        get {
            return self.location.name
        }
    }
    
    private(set) var temperature: String = "-"
    
    private(set) var weatherDescription: String = "-"
    
    private(set) var detailViewModel: LocationDetailViewModel?
    
    func retrieveWeather(completionHandler: () -> ()) {
        self.weatherRetriever.retrieveWeatherWithLatitude(location.latitude, longitude: location.longitude) {
            switch $0 {
            case .Success(let weatherResponse):
                self.temperature = weatherResponse.currentWeather.temperature
                self.weatherDescription = weatherResponse.currentWeather.description
                self.detailViewModel = LocationDetailViewModel(location: self.location, weatherResponse: weatherResponse)
            case .Failure(_):
                self.temperature = "?"
                self.weatherDescription = "?"
            }
            
            completionHandler()
        }
    }
    
}
