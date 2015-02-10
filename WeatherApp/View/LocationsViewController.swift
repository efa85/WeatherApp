//
//  LocationsViewController.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 24/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import UIKit

class LocationsViewController: UITableViewController {
    
    private let viewModel: LocationsViewModel
    
    private let addLocationViewControllerProvider: () -> UIViewController
    
    init(viewModel: LocationsViewModel,
        addLocationViewControllerProvider: () -> UIViewController) {
            
        self.viewModel = viewModel
        self.addLocationViewControllerProvider = addLocationViewControllerProvider
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Locations"
        
        addAddLocationButtonItem()

        configureTableView()

        tableView.reloadData()
    }

    private func configureTableView() {
        let cellNib = UINib(nibName:"LocationTableViewCell", bundle:nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: LocationTableViewCell.cellIdentifier)

        tableView.rowHeight = LocationTableViewCell.heigh

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents:.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    private func addAddLocationButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.Add, target: self, action: "addButtonPressed")
    }
    
    private dynamic func refresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    private dynamic func addButtonPressed() {
        let addLocationViewController = addLocationViewControllerProvider()
        navigationController!.pushViewController(addLocationViewController, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLocations
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LocationTableViewCell.cellIdentifier, forIndexPath: indexPath) as LocationTableViewCell

        let locationViewModel = viewModel.locationViewModelForIndex(indexPath.row)
        
        cell.viewModel = locationViewModel

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            viewModel.deleteLocationAtIndex(indexPath.row)
            tableView.reloadData()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as LocationTableViewCell
        if let locationDetailViewModel = cell.viewModel.detailViewModel {
            let locationDetailViewController = LocationDetailViewController(viewModel: locationDetailViewModel)
            navigationController!.pushViewController(locationDetailViewController, animated: true)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
