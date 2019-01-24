//
//  FilterSelectionTableViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 12/30/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit

class FilterSelectionTableViewController: UITableViewController {

	// Passing functions rather than direct objects to make this class reusable
	var getFunc: (() -> [String: Bool])!
	var selectFunc: ((String, Bool) -> Bool)!
	var selectAllFunc: (() -> Bool)!
    var updateFacilities: (() -> Void)!
	var canSelectAll = true
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		if navigationItem.title = "Alert Notifications" {
			return 2
		}
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section != 0 {
			return 1
		}
		if canSelectAll {
			return 1 + getFunc().count
		}
		return getFunc().count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section != 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "filterSelection", for: indexPath)
			cell.accessoryType = .detailButton
			cell.textLabel?.text = "Open Notifications Settings"
			return cell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "filterSelection", for: indexPath)

		let values = getFunc()
        // Configure the cell...
		if(indexPath.row == 0 && canSelectAll) {
			cell.textLabel?.text = "Select All/None"
			cell.accessoryType = .none
		}
		else {
			var i: Int
			if canSelectAll {
				i = 1
			}
			else {
				i = 0
			}
			for v in values {
				if i == indexPath.row {
					cell.textLabel?.text = v.key.capitalized
					if(v.value == true) {
						cell.accessoryType = .checkmark
					}
					else {
						cell.accessoryType = .none
					}
					break
				}
				i += 1
			}
		}

        return cell
    }
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section != 0 {
			return "The above settings will only apply if you have notifications enabled for What's Open in Settings."
		}
		
		if navigationItem.title == "Show Alerts" {
			return "Emergency Alerts are always enabled in the app for your safety. We will never send a notification to your device without your consent."
		}
		else if navigationItem.title == "Select Maps App" {
			return "The app selected here will be used when opening a map from a facility's detail page."
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section != 0 {
			UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
			return
		}
		
		if(indexPath.row == 0) {
			_ = selectAllFunc()
			tableView.reloadData()
		}
		else {
			let tableCell = tableView.cellForRow(at: indexPath)
			var res: Bool
			if(tableCell?.accessoryType == UITableViewCell.AccessoryType.none) {
				res = true
			}
			else {
				res = false
			}
			_ = selectFunc((tableCell?.textLabel?.text)!.lowercased(), res)
			tableView.reloadData()
		}
        updateFacilities()
	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if(segue.identifier == "toSelection") {
			let destination = segue.destination as! FiltersTableViewController
			destination.tableView.reloadData()
		}
    }
	

}
