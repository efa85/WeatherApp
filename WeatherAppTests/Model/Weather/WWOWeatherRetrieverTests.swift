//
//  WWOWeatherRetrieverTests.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 25/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import XCTest

class WWOWeatherRetrieverTests: XCTestCase {
    
    let baseUrl = "testProtocol://testHost/testPath"
    let apiKey = "9b55045cc1d6ee3e6d2be5fb019de"
    
    var sut: WeatherRetriever!

    override func setUp() {
        super.setUp()
        
        let configuration = WWOWeatherRetriever.Configuration(baseUrl: NSURL(string: self.baseUrl)!, apiV2Key: apiKey)
        let responseDataParser = WWOResponseDataParser()
        sut = WWOWeatherRetriever(configuration: configuration, responseDataParser: responseDataParser)
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        
        sut = nil;
        
        super.tearDown()
    }
    
    func test__retrieveWeatherWithLatitude__passing_valid_coordinates__the_weather_is_retrieved() {
        // prepare
        let latitude = "50.0880400"
        let longitude = "14.4207600"
        
        stubRequestWithLatitude(latitude, longitude: longitude, responseFile: "weather.json")
        
        let expectation = expectationWithDescription("")
        
        // test
        sut.retrieveWeatherWithLatitude(latitude, longitude: longitude) {
            switch $0 {
            case .Success(let weatherResponse):
                XCTAssertEqual(weatherResponse.currentWeather.temperature, "2")
                XCTAssertEqual(weatherResponse.currentWeather.description, "Fog")
                XCTAssertEqual(weatherResponse.currentWeather.iconURL, "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0007_fog.png")
                XCTAssertEqual(weatherResponse.astronomy.sunrise, "07:31 AM")
                XCTAssertEqual(weatherResponse.astronomy.sunset, "04:07 PM")
                expectation.fulfill()
            case .Failure(let error):
                break
            }
        }
        
        // verify
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func test__retrieveWeatherWithLatitude__passing_invalid_coordinates__retrieves_error_with_the_response_message() {
        // prepare
        let latitude = "invalidLat"
        let longitude = "invalidLong"
        
        stubRequestWithLatitude(latitude, longitude: longitude, responseFile: "error.json")
        
        let expectation = expectationWithDescription("")
        
        // test
        sut.retrieveWeatherWithLatitude(latitude, longitude: longitude) {
            switch $0 {
            case .Success(_):
                break
            case .Failure(let error):
                XCTAssertEqual(error.localizedDescription, "errorMessage")
                expectation.fulfill()
            }
        }
        
        // verify
        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func test__retrieveWeatherWithLatitude__when_invalid_json_is_received__retrieves_the_parser_error() {
        // prepare
        let latitude = "50.0880400"
        let longitude = "14.4207600"
        
        stubRequestWithLatitude(latitude, longitude: longitude, responseFile: "nojson")
        
        let expectation = expectationWithDescription("")
        
        // test
        sut.retrieveWeatherWithLatitude(latitude, longitude: longitude) {
            switch $0 {
            case .Success(_):
                break
            case .Failure(let error):
                XCTAssertEqual(error.domain, "NSCocoaErrorDomain")
                let expectedCode = 3840
                XCTAssertEqual(error.code, expectedCode)
                expectation.fulfill()
            }
        }
        
        // verify
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func test__retrieveWeatherWithLatitude__when_unexpected_json_is_received__retrieves_the_expected_error() {
        // prepare
        let latitude = "50.0880400"
        let longitude = "14.4207600"
        
        stubRequestWithLatitude(latitude, longitude: longitude, responseFile: "unexpected.json")
        
        let expectation = expectationWithDescription("")

        // test
        sut.retrieveWeatherWithLatitude(latitude, longitude: longitude) {
            switch $0 {
            case .Success(_):
                break
            case .Failure(let error):
                XCTAssertEqual(error.domain, WWOWeatherRetrieverDomain)
                let expectedCode = WWOWeatherRetrieverErrorCode.UnexpectedJson.rawValue
                XCTAssertEqual(error.code, expectedCode)
                expectation.fulfill()
            }
        }
        
        // verify
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func test__retrieveWeatherWithLatitude__with_connection_error__retrieves_error() {
        // prepare
        let latitude = "someLat"
        let longitude = "someLong"
        let connectionError = NSError(domain: "testDomain", code: 0, userInfo: nil)
        
        stubRequestWithLatitude(latitude, longitude: longitude, connectionError: connectionError)
        
        let expectation = expectationWithDescription("")
        
        // test
        sut.retrieveWeatherWithLatitude(latitude, longitude: longitude) {
            switch $0 {
            case .Success(_):
                break
            case .Failure(let error):
                XCTAssertEqual(error, connectionError)
                expectation.fulfill()
            }
        }
        
        // verify
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    private func stubRequestWithLatitude(latitude: String, longitude: String, responseFile: String) {
        let expectedURL = "\(baseUrl)?q=\(latitude),\(longitude)&format=json&key=\(apiKey)"
        
        OHHTTPStubs.stubRequestsPassingTest({ (request) -> Bool in
            return request.URL.absoluteString == expectedURL
            },
            withStubResponse: { (request) -> OHHTTPStubsResponse! in
                let responsePath = NSBundle(forClass: WWOWeatherRetrieverTests.self).pathForResource(responseFile, ofType: nil)!
                return OHHTTPStubsResponse(fileAtPath: responsePath, statusCode: 200, headers: nil)
        })
    }
    
    private func stubRequestWithLatitude(latitude: String, longitude: String, connectionError: NSError) {
        let expectedURL = "\(baseUrl)?q=\(latitude),\(longitude)&format=json&key=\(apiKey)"
        
        OHHTTPStubs.stubRequestsPassingTest({ (request) -> Bool in
            return request.URL.absoluteString == expectedURL
            },
            withStubResponse: { (request) -> OHHTTPStubsResponse! in
                return OHHTTPStubsResponse(error: connectionError)
        })
    }

}
