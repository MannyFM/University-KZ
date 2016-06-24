//
//  SpecialityDetailsViewController.swift
//  University.kz
//
//  Created by Alibek Manabayev on 23.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class SpecialityDetailsViewController: UIViewController {

    weak var university : University?
    weak var city : City?
    var speciality = Speciality()
    
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.university = self.speciality.university
        self.city = self.university?.city
        
        navigationController?.title = university?.fullName
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
