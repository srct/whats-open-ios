//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Zach Knox on 9/30/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit
import NotificationCenter
import WhatsOpenKit
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
	
	
	let realm = try! Realm(configuration: WOPDatabaseController.getConfig())
	
	var facilitiesArray = List<WOPFacility>()
	
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		let results = realm.objects(WOPFacilitiesModel.self)
		if results.count > 0 {
			let model = results[0]
			let facilities = model.facilities
			facilitiesArray = facilities.filter({ (facility: WOPFacility) -> Bool in
				return WOPUtilities.isFavoriteFacility(facility)
			})
		}
        // Do any additional setup after loading the view from its nib.
		
		tableView.reloadData()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return facilitiesArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "todayWidgetCell", for: indexPath)
		
		let facility = facilitiesArray[indexPath.row]
		cell.textLabel!.text = facility.facilityName
		let isopen = WOPUtilities.isOpen(facility: facility)
		if isopen {
			cell.detailTextLabel!.text = "Open"
		} else {
			cell.detailTextLabel!.text = "Closed"
		}
		
		return cell
	}
    
}
