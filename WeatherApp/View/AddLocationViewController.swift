//
//  AddLocationViewController.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 12/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    private let viewModel: AddLocationViewModel
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    init(viewModel: AddLocationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: "AddLocationViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LocalizedStrings.addLocationTitle
        
        addSaveButtonItem()
        addMapTapViewGestureRecognizer()
        
        updateSaveButtonItemEnabled()
    }
    
    private func addSaveButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.Save, target: self, action: "saveButtonPressed")
    }
    
    private dynamic func saveButtonPressed() {
        switch viewModel.addLocation() {
        case .Success:
            self.navigationController!.popViewControllerAnimated(false)
        case .Error:
            break
        }
    }
    
    private func addMapTapViewGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "mapTapped:")
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private dynamic func mapTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedPoint = gestureRecognizer.locationInView(mapView)
        let coordinate = mapView.convertPoint(tappedPoint, toCoordinateFromView: mapView)
        
        mapView.setUniquePointAnnotationWithCoordinate(coordinate)
        viewModel.coordinate = (coordinate.latitude, coordinate.longitude)
        
        updateSaveButtonItemEnabled()
    }
    
    private func updateSaveButtonItemEnabled() {
        self.navigationItem.rightBarButtonItem?.enabled = viewModel.isInputValid
    }
    
    @IBAction func nameTextFieldEditingChanged(sender: AnyObject) {
        viewModel.name = nameField.text
        
        updateSaveButtonItemEnabled()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}