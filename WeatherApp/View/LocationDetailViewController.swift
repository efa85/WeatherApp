//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 15/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController {
    
    let viewModel: LocationDetailViewModel
    
    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: "LocationDetailViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var sunriseIndicatorLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    
    @IBOutlet weak var sunsetIndicatorLabel: UILabel!
    
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.locationName
        weatherDescriptionLabel.text = viewModel.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
