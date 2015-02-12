//
//  Container.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 25/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import UIKit

class Container {
    
    struct Configuration {
        let wwoBaseUrl: String
        let wwoApiV2Key: String
        let modelName: String
        let storeName: String
    }
    
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func resolveRootViewController() -> UIViewController {
        let viewController = resolveLocationsViewController()
        return UINavigationController(rootViewController: viewController)
    }
    
    func resolveLocationsViewController() -> LocationsViewController {
        return LocationsViewController(
            viewModel: resolveLocationsViewModel(),
            addLocationViewControllerProvider: resolveAddLocationViewControllerProvider()
        )
    }
    
    func resolveLocationsViewModel() -> LocationsViewModel {
        let locationStore = resolveLocationStore()
        
        return LocationsViewModel(locationsStore: locationStore, locationViewModelProvider:resolveLocationViewModelProvider())
    }
    
    func resolveLocationViewModelProvider() -> (location: Location) -> (LocationViewModel) {
        return { location in
            return LocationViewModel(location: location, weatherRetriever: self.weatherRetriever)// TODO: retain cycle?
        }
    }
    
    func resolveAddLocationViewControllerProvider() -> () -> (AddLocationViewController) {
        return { [unowned self] in
            let viewModel = AddLocationViewModel(locationStore: self.resolveLocationStore())
            return AddLocationViewController(viewModel: viewModel)
        }
    }
    
    func resolveLocationStore() -> LocationStore {
        return CoreDataLocationStore(context: coreDataStack.mainQueueContext)
    }
    
    private lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack.withModelName(self.configuration.modelName, storeType: .SQLite(storeName: self.configuration.storeName))
    }()
    
    private lazy var weatherRetriever: WeatherRetriever = {
        return WWOWeatherRetriever(configuration: self.resolveWWOConfiguration(),
                              responseDataParser: self.resolveResponseDataParser())
    }()
    
    func resolveWWOConfiguration() -> WWOWeatherRetriever.Configuration {
        let baseUrl = NSURL(string: configuration.wwoBaseUrl)!
        return WWOWeatherRetriever.Configuration(baseUrl: baseUrl, apiV2Key: configuration.wwoApiV2Key)
    }
    
    func resolveResponseDataParser() -> WWOResponseDataParser {
        return WWOResponseDataParser()
    }
    
}
