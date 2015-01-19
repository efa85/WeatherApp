//
//  Location.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 31/12/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import Foundation

protocol Location {
    var name: String { get }
    var latitude: String { get }
    var longitude: String { get }
}
