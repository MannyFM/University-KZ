//
//  UniversitiesTableViewController.swift
//  University.kz
//
//  Created by Alibek Manabayev on 23.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class UniversitiesTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    let cellIdentifier : String = "UniversityCell"
    let segueIdentifier : String = "DetailsSegue"
    
    var city = City()
    var universities = [University]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = city.name
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(CitiesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.refresh(self)
        
        self.saveTempUniversiy()
    }
    
    
    func refresh(sender: AnyObject) {
        self.getAllUniversitiesAsync()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UniversityTableViewCell

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(segueIdentifier, sender: indexPath)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == segueIdentifier) {
            let VC = segue.destinationViewController
            let vc = segue.destinationViewController as! UniversityTabBarController
            let index = (sender as! NSIndexPath).row
            vc.university = universities[index]
        }
    }
    
    //MARK: - Backendless
    
    func getAllUniversitiesAsync() {
        let dataStore = Backendless.sharedInstance().data.of(University.ofClass())
        
        dataStore.find(
            { (result: BackendlessCollection!) -> Void in
                self.universities = []
                let contacts = result.getCurrentPage()
                for obj in contacts {
                    let university = obj as! University
                    self.universities.append(university)
                }
                print("universities downloaded")
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    func saveTempUniversiy() {
        let university = University()
        
        let dataStore = Backendless.sharedInstance().data.of(University.ofClass())
        
        dataStore.save(university, response: { (result : AnyObject!) in
            let obj = result as! University
            print("object swas benn saved \(obj)")
        }) { (fault : Fault!) in
            print("Server error: \(fault)")
        }
    }
}
