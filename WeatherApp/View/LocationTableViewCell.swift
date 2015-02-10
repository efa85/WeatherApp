//
//  LocationTableViewCell.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 24/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    class var heigh: CGFloat {
        get {
            return 78
        }
    }
    
    class var cellIdentifier: String {
        get {
            return "LocationCellId"
        }
    }
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    var viewModel: LocationViewModel! {
        didSet {
            updateContent()
        }
    }
    
}

private extension LocationTableViewCell {
    
    func updateContent() {
        locationNameLabel.text = viewModel.locationName
        updateWeatherLabels()
        
        viewModel.retrieveWeather { [unowned self] in
            dispatch_async(dispatch_get_main_queue()) {
                self.updateWeatherLabels()
            }
        }
    }
    
    func updateWeatherLabels() {
        temperatureLabel.text = viewModel.temperature
        weatherDescriptionLabel.text = viewModel.weatherDescription
    }

}
