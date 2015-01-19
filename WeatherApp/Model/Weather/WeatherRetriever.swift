//
//  WeatherRetriever.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 25/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import Foundation

enum WeatherResult {
    case Success(WeatherResponse)
    case Failure(NSError)
}

protocol WeatherRetriever {
    
    func retrieveWeatherWithLatitude(latitude: String, longitude: String, completionHandler: (WeatherResult) -> ())
    
}
