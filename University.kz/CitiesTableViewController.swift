//
//  CitiesTableViewController.swift
//  University.kz
//
//  Created by Alibek Manabayev on 23.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class CitiesTableViewController: UITableViewController {

    let cellIdentifier : String = "CityCell"
    
    
    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAllCitiesAsync()
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CityTableViewCell

        let index = indexPath.row
        
        //put placeholder <------------------------------------------------------------------------------------------------------------------------------------------------->
        cell.imageView?.loadImageFromURLString(cities[index].imageURL!, placeholderImage: nil, completion: nil)
        
        cell.cityNameLabel.text = cities[index].name
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: - Backendless
    
    func getAllCitiesAsync() {
        let dataStore = Backendless.sharedInstance().data.of(City.ofClass())
        
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                let contacts = result.getCurrentPage()
                for obj in contacts {
                    let city = obj as! City
                    self.cities.append(city)
                }
                print("cities downloaded")
                self.tableView.reloadData()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
}
