//
//  LocalizedStrings.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 14/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import Foundation

// TODO use enum instead?
// with an enum, it would be easier(with a switch) to test that all strings are translated in the supported languages
class LocalizedStrings {
    
    class var locationsTitle: String {
        get {
            return NSLocalizedString("LOCATIONS_TITLE", comment:"")
        }
    }
    
    class var addLocationTitle: String {
        get {
            return NSLocalizedString("ADD_LOCATION_TITLE", comment:"")
        }
    }
    
    class var sunriseIndicator: String {
        get {
            return NSLocalizedString("SUNRISE_INDICATOR", comment:"")
        }
    }
    
    class var sunsetIndicator: String {
        get {
            return NSLocalizedString("SUNSET_INDICATOR", comment:"")
        }
    }
    
}