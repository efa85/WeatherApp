//
//  LocationWeatherCellViewModelTests.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 25/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import XCTest
import CoreData

class LocationViewModelTests: XCTestCase {
    
    let locationName = "aLocationName"
    let latitude = "50.0880400"
    let longitude = "14.4207600"
    
    var sut: LocationViewModel!
    var weatherRetrieverMock: MockWeatherRetriever!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        let coreDataStack = CoreDataStack(modelName: "Locations.momd", type: .InMemory, substitutionSwiftModuleName:"WeatherAppTests")
        context = coreDataStack.mainQueueContext
        
        let location = createLocationWithName(locationName, latitude: latitude, longitude: longitude)
        weatherRetrieverMock = MockWeatherRetriever()
        sut = LocationViewModel(location:location, weatherRetriever:weatherRetrieverMock)
    }
    
    override func tearDown() {
        weatherRetrieverMock = nil
        sut = nil
        context = nil

        super.tearDown()
    }

    func test__locationName() {
        XCTAssertEqual(sut.locationName, locationName)
    }
    
    func test__temperature_and_weatherDescription__initially_have_a_dash() {
        XCTAssertEqual(sut.temperature, "-")
        XCTAssertEqual(sut.weatherDescription, "-")
    }
    
    func test__retrieveWeather__when_the_weather_retriever_succeeds__calls_the_completionHandler_and_the_temperature_and_weatherDescription_have_the_expected_value() {
        // prepare
        let expectedTemperature = "temp"
        let expectedWeatherDescription = "description"
        let weather = Weather(temperature: expectedTemperature, description: expectedWeatherDescription, iconURL: "")
        let weatherResponse = WeatherResponse(currentWeather: weather, astronomy: Astronomy(sunrise: "", sunset: ""))
        weatherRetrieverMock.weatherResultToPassToCompletionHandler = .Success(weatherResponse)
        
        // test
        var wasCalled = false
        sut.retrieveWeather {
            wasCalled = true
        }
        
        // verify
        XCTAssertTrue(wasCalled)
        XCTAssertEqual(weatherRetrieverMock.passedLatitude, latitude)
        XCTAssertEqual(weatherRetrieverMock.passedLongitude, longitude)
        XCTAssertEqual(sut.temperature, expectedTemperature)
        XCTAssertEqual(sut.weatherDescription, expectedWeatherDescription)
    }

    func test__retrieveWeather__when_the_weather_retriever_fails__calls_the_completionHandler_and_the_temperature_and_weatherDescription_have_a_questionmark() {
        // prepare
        let expectedErrorDescription = "errorDescription"
        let retrieverError = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: expectedErrorDescription])
        weatherRetrieverMock.weatherResultToPassToCompletionHandler = .Failure(retrieverError)
        
        // test
        var wasCalled = false
        sut.retrieveWeather {
            wasCalled = true
        }
        
        // verify
        XCTAssertTrue(wasCalled)
        XCTAssertEqual(weatherRetrieverMock.passedLatitude, latitude)
        XCTAssertEqual(weatherRetrieverMock.passedLongitude, longitude)
        XCTAssertEqual(sut.temperature, "?")
        XCTAssertEqual(sut.weatherDescription, "?")
    }
    
    class MockWeatherRetriever: WeatherRetriever {
        
        private(set) var passedLatitude: String!
        private(set) var passedLongitude: String!
        var weatherResultToPassToCompletionHandler: WeatherResult!
        
        init() {
            
        }
        
        func retrieveWeatherWithLatitude(latitude: String, longitude: String, completionHandler: (WeatherResult) -> ()) {
            passedLatitude = latitude
            passedLongitude = longitude
            completionHandler(weatherResultToPassToCompletionHandler)
        }
    }
    
    private func createLocationWithName(name: String, latitude: String, longitude: String) -> Location {
        let location = NSEntityDescription.insertNewObjectForEntityForName(Location.entityName, inManagedObjectContext: context) as Location
        location.name = name
        location.latitude = latitude
        location.longitude = longitude
        
        return location
    }

}
