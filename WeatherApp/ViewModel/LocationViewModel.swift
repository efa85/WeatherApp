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
    
    enum RetrieveWeatherResult {
        case Success(String, String)
        case Failure(String)
    }
    
    func retrieveWeather(completionHandler: (RetrieveWeatherResult) -> ()) {
        self.weatherRetriever.retrieveWeatherWithLatitude(location.latitude, longitude: location.longitude) {
            switch $0 {
            case .Success(let weatherResponse):
                self.detailViewModel = LocationDetailViewModel(location: self.location, weatherResponse: weatherResponse)
                completionHandler(.Success(
                    weatherResponse.currentWeather.temperature,
                    weatherResponse.currentWeather.description
                    ))
            case .Failure(let error):
                let errorMessage = error.localizedDescription
                completionHandler(.Failure(errorMessage))
                break
            }
        }
    }
    
    private(set) var detailViewModel: LocationDetailViewModel?
    
}
