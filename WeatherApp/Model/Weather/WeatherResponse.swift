//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 15/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

struct WeatherResponse {
    let currentWeather: Weather
    let astronomy: Astronomy
}

struct Weather {
    let temperature: String
    let description: String
    let iconURL: String
}

struct Astronomy {
    let sunrise: String
    let sunset: String
}
