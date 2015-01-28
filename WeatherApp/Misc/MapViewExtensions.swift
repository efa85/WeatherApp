//
//  MapViewExtensions.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 28/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import MapKit

extension MKMapView {
    
    func setUniquePointAnnotationWithCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        removeAnnotations(annotations)
        addAnnotation(annotation)
    }
    
}
