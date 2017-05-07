//
//  LocationDetailViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var PlaceLabel: UILabel!
	@IBOutlet var openLabel: UILabel!

	@IBOutlet var OpenTimesList: UITableView!
	
	@IBOutlet var detailStackView: UIStackView!
	
	var facility: Facility!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		//SET STACK VIEW DISTRIBUTION HERE
	}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func MiddleButton(_ sender: Any) {
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 7
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = OpenTimesList.dequeueReusableCell(withIdentifier: "LocationDetailCell", for: indexPath)
		
		
		// Configure the cell...
		
		return cell
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
