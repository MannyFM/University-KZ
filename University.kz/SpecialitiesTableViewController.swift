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
        return specialities.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //0. ENT for Altin Belgi
        //1. ENT for Norm
        //2. ENT for Auto
        //3. ENT for Winner
        //4. ENT for Village
        //5. speciality id
        return 6
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SpecialityTableViewCell
        
        let index = indexPath.section
        let spec = specialities[index]
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Минимальный балл ЕНТ для обладателей знака «Алтын белгі»"
            cell.detailTextLabel?.text = "\(spec.minENTAB)"
        case 1:
            cell.textLabel?.text = "Минимальный балл ЕНТ для смертных"  //<<<<<<<<<<<==================================================================
            //Лица, не являющиеся обладателями преимущественного права
            cell.detailTextLabel?.text = "\(spec.minENTProst)"
        case 2:
            cell.textLabel?.text = "Минимальный балл ЕНТ для выпускников автономных организаций образования"
            cell.detailTextLabel?.text = "\(spec.minENTAuto)"
        case 3:
            cell.textLabel?.text = "Минимальный балл ЕНТ для победителей международных, республиканских и президентских олимпиад, научных и спортивных соревнований"
            cell.detailTextLabel?.text = "\(spec.minENTWinner)"
        case 4:
            cell.textLabel?.text = "Минимальный балл ЕНТ для обладателей сельской квоты"
            cell.detailTextLabel?.text = "\(spec.minENTVillage)"
        case 5:
            cell.textLabel?.text = "ID специальности"
            cell.detailTextLabel?.text = spec.id ?? "---"
        default: break
            //
        }
        
        return cell
    }
    
    // MARK: Header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.whiteColor()
        
        return vw
    }
    
    // MARK: - Navigation
    
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
