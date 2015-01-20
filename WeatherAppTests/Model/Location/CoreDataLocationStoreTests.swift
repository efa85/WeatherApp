//
//  CoreDataLocationStoreTests.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 06/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import XCTest
import CoreData
import WeatherApp

class CoreDataLocationStoreTests: XCTestCase {
    
    let modelName = "Locations.momd"
    let storeName = "TestLocations.sqlite"
    
    var sut: LocationStore!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataStack(modelName: modelName, type: .SQLite(storeName: storeName), substitutionSwiftModuleName:"WeatherAppTests")
        
        deleteStore()
        
        sut = CoreDataLocationStore(context: coreDataStack.mainQueueContext)
    }
    
    override func tearDown() {
        deleteStore()
        sut = nil
        coreDataStack = nil
        
        super.tearDown()
    }
    
    func test__initially_there_are_no_locations() {
        XCTAssertEqual(sut.fetchLocations().count, 0)
    }
    
    func test__adding_a_location() {
        // prepare
        XCTAssertEqual(sut.fetchLocations().count, 0)
        
        let name = "aName"
        let latitude = "aLat"
        let longitude = "aLong"
        
        // test
        sut.addLocationWithName(name, latitude: latitude, longitude: longitude)
        
        // verify
        let locations = sut.fetchLocations()
        if locations.count == 1 {
            let location = locations[0]
            XCTAssertEqual(location.name, name)
            XCTAssertEqual(location.latitude, latitude)
            XCTAssertEqual(location.longitude, longitude)
        }
        else {
            XCTFail()
        }
    }
    
    func test__add_a_location_then_tear_down_the_stack_and_add_a_new_one() {
        XCTAssertEqual(sut.fetchLocations().count, 0)
        
        let name1 = "aName"
        sut.addLocationWithName(name1, latitude: "aLat", longitude: "aLong")
        
        XCTAssertEqual(sut.fetchLocations().count, 1)
        
        coreDataStack = CoreDataStack(modelName: modelName, type: .SQLite(storeName: storeName), substitutionSwiftModuleName:"WeatherAppTests")
        sut = CoreDataLocationStore(context: coreDataStack.mainQueueContext)
        
        XCTAssertEqual(sut.fetchLocations().count, 1)

        let name2 = "otherName"
        sut.addLocationWithName(name2, latitude: "aLat", longitude: "aLong")
        
        XCTAssertEqual(sut.fetchLocations().count, 2)
        
        let names = sut.fetchLocations().map() {
            (location) -> String in
            return location.name
        }
        XCTAssertTrue(contains(names, name1))
        XCTAssertTrue(contains(names, name2))
    }
    
    func test__deleteLocation() {
        XCTAssertEqual(sut.fetchLocations().count, 0)
        
        sut.addLocationWithName("aName", latitude: "aLat", longitude: "aLong")
        
        XCTAssertEqual(sut.fetchLocations().count, 1)
        
        let location = sut.fetchLocations()[0]
        sut.deleteLocation(location)
        
        XCTAssertEqual(sut.fetchLocations().count, 0)
    }
    
    private func deleteStore() {
        let storeUrl = coreDataStack.storeUrl!
        NSFileManager.defaultManager().removeItemAtURL(storeUrl, error: nil)
    }

}
