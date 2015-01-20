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
    
    func test__retrieveWeather__when_the_weather_retriever_succeed__retrieves_the_weather_for_the_given_location() {
        // prepare
        let expectedTemperature = "temp"
        let expectedWeatherDescription = "description"
        let weather = Weather(temperature: expectedTemperature, description: expectedWeatherDescription, iconURL: "")
        let weatherResponse = WeatherResponse(currentWeather: weather, astronomy: Astronomy(sunrise: "", sunset: ""))
        weatherRetrieverMock.weatherResultToPassToCompletionHandler = .Success(weatherResponse)
        
        // test
        var retrievedTemperature: String!
        var retrievedWeatherDescription: String!
        sut.retrieveWeather {
            switch $0 {
            case let .Success(temperature, weatherDescription):
                retrievedTemperature = temperature
                retrievedWeatherDescription = weatherDescription
            case .Failure(_):
                XCTFail()
            }
        }
        
        // verify
        XCTAssertEqual(weatherRetrieverMock.passedLatitude, latitude)
        XCTAssertEqual(weatherRetrieverMock.passedLongitude, longitude)
        XCTAssertEqual(retrievedTemperature, expectedTemperature)
        XCTAssertEqual(retrievedWeatherDescription, expectedWeatherDescription)
    }
    
    func test__retrieveWeather__when_the_weather_retriever_fails__retrieves_the_error_message() {
        // prepare
        let expectedErrorDescription = "errorDescription"
        let retrieverError = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: expectedErrorDescription])
        weatherRetrieverMock.weatherResultToPassToCompletionHandler = .Failure(retrieverError)
        
        // test
        var retrievedErrorDescription: String!
        sut.retrieveWeather {
            switch $0 {
            case let .Success(_, _):
                XCTFail()
            case let .Failure(errorDescription):
                retrievedErrorDescription = errorDescription
            }
        }
        
        // verify
        XCTAssertEqual(weatherRetrieverMock.passedLatitude, latitude)
        XCTAssertEqual(weatherRetrieverMock.passedLongitude, longitude)
        XCTAssertEqual(retrievedErrorDescription, expectedErrorDescription)
    }
    
    class MockWeatherRetriever: WeatherRetriever {
        
        private(set) var passedLatitude: String!
        private(set) var passedLongitude: String!
        var weatherResultToPassToCompletionHandler: WeatherResult!
        
        init() {
            
        }
        
        func retrieveWeatherWithLatitude(latitude: String, longitude: String, completionHandler: (WeatherResult) -> ()) {
            self.passedLatitude = latitude
            self.passedLongitude = longitude
            completionHandler(self.weatherResultToPassToCompletionHandler)
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
