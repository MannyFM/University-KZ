//
//  SpecialitiesTableViewController.swift
//  University.kz
//
//  Created by Alibek Manabayev on 23.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class SpecialitiesTableViewController: UITableViewController {

    let cellIdentifier : String = "SpecialityCell"
    let segueIdentifier : String = "DetailsSegue"
    
    var specialities = [Speciality]()
    weak var university : University?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(CitiesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.navigationController?.title = university?.shortName
        
        self.refresh(nil)
        
    }
    
    func refresh(sender: AnyObject?) {
        self.getSpecialitiesInAsync(self.university!)
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SpecialityTableViewCell
        
        let index = indexPath.row
        cell.textLabel?.text = specialities[index].name
        
        return cell
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            let vc = segue.destinationViewController as! SpecialityDetailsViewController
            let index = (sender as! NSIndexPath).row
            vc.speciality = specialities[index]
        }
    }
    
    func getSpecialitiesInAsync(university : University) {
        let whereClause = "university.shortname = \'\(university.shortName!)\'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        let dataStore = Backendless.sharedInstance().data.of(Speciality.ofClass())
        
        dataStore.find(dataQuery,
                       response: { (result: BackendlessCollection!) -> Void in
                        self.specialities = []
                        let contacts = result.getCurrentPage()
                        for obj in contacts {
                            let speciality = obj as! Speciality
                            self.specialities.append(speciality)
                        }
                        print("specialities downloaded")
                        self.tableView.reloadData()
                        self.refreshControl!.endRefreshing()
            },
                       error: { (fault: Fault!) -> Void in
                        print("Server reported an error: \(fault)")
        })
        
    }


}
