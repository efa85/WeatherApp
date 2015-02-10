//
//  AddLocationViewModelTests.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 07/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import UIKit
import XCTest

class AddLocationViewModelTests: XCTestCase {

    var locationStoreMock: MockLocationStore!
    var sut: AddLocationViewModel!

    override func setUp() {
        super.setUp()
        
        locationStoreMock = MockLocationStore()
        sut = AddLocationViewModel(locationStore: locationStoreMock)
    }
    
    override func tearDown() {
        locationStoreMock = nil
        sut = nil
        
        super.tearDown()
    }

    func test__addLocation__with_valid_name_and_coordinate__returns_success_and_adds_the_location_to_the_store() {
        // prepare
        let name = "aName"
        let latitude = 50.12
        let longitude = 1.9

        // test
        sut.name = name
        sut.coordinate = (latitude, longitude)
        let result = sut.addLocation()
        
        // verify
        switch result {
        case .Success:
            XCTAssertEqual(locationStoreMock.passedName, name)
            XCTAssertEqual(locationStoreMock.passedLatitude, "50.12")
            XCTAssertEqual(locationStoreMock.passedLongitude, "1.9")
        case .Error:
            XCTFail()
        }
    }
    
    func test__addLocation__with_the_name_and_coordinate_not_set__returns_error_result() {
        // prepare

        // test
        let result = sut.addLocation()
        
        // verify
        switch result {
        case .Success:
            XCTFail()
        case .Error:
            break
        }
    }

    func test__addLocation__with_the_name_set_and_coordinate_not_set__returns_error_result() {
        // prepare

        // test
        sut.name = "aName"
        let result = sut.addLocation()
        
        // verify
        switch result {
        case .Success:
            XCTFail()
        case .Error:
            break
        }
    }

    func test__addLocation__with_the_name_not_set_and_coordinate_set__returns_error_result() {
        // prepare

        // test
        sut.coordinate = (2.33, 1.5)
        let result = sut.addLocation()
        
        // verify
        switch result {
        case .Success:
            XCTFail()
        case .Error:
            break
        }
    }
    
    func test__isInputValid__initially__is_false() {
        // prepare
        
        // test
        let isInputValid = sut.isInputValid
        
        // verify
        XCTAssertFalse(isInputValid)
    }
    
    func test__isInputValid__with_valid_name_and_coordinates_set__is_true() {
        // prepare
        sut.name = "valid name"
        sut.coordinate = (1.0, 2.0)
        
        // test
        let isInputValid = sut.isInputValid
        
        // verify
        XCTAssertTrue(isInputValid)
    }
    
    func test__isInputValid__with_valid_name_and_coordinates_not_set__is_false() {
        // prepare
        sut.name = "valid name"
        
        // test
        let isInputValid = sut.isInputValid
        
        // verify
        XCTAssertFalse(isInputValid)
    }
    
    func test__isInputValid() {
        sut.name = "" // invalid
        XCTAssertFalse(sut.isInputValid)
        
        sut.name = "valid name"
        XCTAssertFalse(sut.isInputValid)
        
        sut.coordinate = (3, 3)
        XCTAssertTrue(sut.isInputValid)
        
        sut.name = "aa" // invalid: 3 characters minimun
        XCTAssertFalse(sut.isInputValid)
    }
    
    class MockLocationStore: LocationStore {

        var passedName: String!
        var passedLatitude: String!
        var passedLongitude: String!
        
        func fetchLocations() -> [Location] {
            return []
        }
        
        func addLocationWithName(name: String, latitude: String, longitude: String) {
            passedName = name
            passedLatitude = latitude
            passedLongitude = longitude
        }
        
        func deleteLocation(location: Location) {
        }

    }

}
