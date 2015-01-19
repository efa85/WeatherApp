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
        let wwoApiKey: String
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
        return { (location) in
            return LocationViewModel(location: location, weatherRetriever: self.weatherRetriever)// TODO retain cycle?
        }
    }
    
    func resolveAddLocationViewControllerProvider() -> () -> (AddLocationViewController) {
        return { [unowned self]
            () in
            let viewModel = AddLocationViewModel(locationStore: self.resolveLocationStore())
            return AddLocationViewController(viewModel: viewModel)
        }
    }
    
    func resolveLocationStore() -> LocationStore {
        return CoreDataLocationStore(context: coreDataStackManager.mainQueueContext)
    }
    
    private lazy var coreDataStackManager: CoreDataStackManager = {
        return CoreDataStackManager(modelName: self.configuration.modelName, storeName: self.configuration.storeName)
    }()
    
    private lazy var weatherRetriever: WeatherRetriever = {
        return WWOWeatherRetriever(configuration: self.resolveWWOConfiguration(),
                              responseDataParser: self.resolveResponseDataParser())
    }()
    
    func resolveWWOConfiguration() -> WWOWeatherRetriever.Configuration {
        let baseUrl = NSURL(string: configuration.wwoBaseUrl)!
        return WWOWeatherRetriever.Configuration(baseUrl: baseUrl, apiKey: configuration.wwoApiKey)
    }
    
    func resolveResponseDataParser() -> WWOResponseDataParser {
        return WWOResponseDataParser()
    }
    
}
