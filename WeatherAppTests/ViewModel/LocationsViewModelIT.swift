//
//  LocationsViewModelIT.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 22/12/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import XCTest
import CoreData

class LocationsViewModelIT: XCTestCase {
    
    var sut: LocationsViewModel!
    
    override func setUp() {
        super.setUp()
        
        let baseUrl = "http://test/free/v2/weather.ashx"
        let apiKey = "fddhdfhdfh"
        
        let configuration = Container.Configuration(
            wwoBaseUrl: baseUrl,
            wwoApiKey: apiKey,
            modelName: "Locations",
            storeName: "testStore.sqlite"
        )
        
        let container = Container(configuration: configuration)
        
//        self.insertTestLocationsIntoContext()
        
//        sut = container.resolveLocationsViewModel(); TODO crashes
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    private func insertTestLocationsIntoContext(context: NSManagedObjectContext) {
        
    }

}
