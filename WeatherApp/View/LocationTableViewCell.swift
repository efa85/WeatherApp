//
//  LocationTableViewCell.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 24/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    class func heigh() -> CGFloat {
        return 127
    }
    
    class func cellIdentifier() -> String {
        return "CellId"
    }
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatheriIconImageView: UIImageView!
    @IBOutlet weak var greyOutView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: LocationViewModel! {
        didSet {
            updateContent()
        }
    }
    
}

private extension LocationTableViewCell {
    
    func updateContent() {
        self.showGreyOutView()
        
        self.locationNameLabel.text = self.viewModel.locationName
        updateWeatherLabels()
        
        self.viewModel.retrieveWeather { [unowned self] () in
            self.updateWeatherLabels()
            
            self.hideGreyOutView()
        }
    }
    
    func updateWeatherLabels() {
        self.temperatureLabel.text = self.viewModel.temperature
        self.weatherDescriptionLabel.text = self.viewModel.weatherDescription
    }
    
    func showGreyOutView() {
        self.activityIndicator.startAnimating()
        self.greyOutView.hidden = false
    }
    
    func hideGreyOutView() {
        self.activityIndicator.stopAnimating()
        self.greyOutView.hidden = true
    }

}
