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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1 + getFunc().count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterSelection", for: indexPath)

		let values = getFunc()
        // Configure the cell...
		if(indexPath.row == 0) {
			cell.textLabel?.text = "Select All/None"
			cell.accessoryType = .none
		}
		else {
			var i = 1
			for v in values {
				if i == indexPath.row {
					cell.textLabel?.text = v.key
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
		if navigationItem.title == "Alerts" {
			return "Emergency Alerts are always enabled in the app for your safety. We will never send a notification to your device without your consent."
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if(indexPath.row == 0) {
			selectAllFunc()
			tableView.reloadData()
		}
		else {
			let tableCell = tableView.cellForRow(at: indexPath)
			var res: Bool
			if(tableCell?.accessoryType == UITableViewCellAccessoryType.none) {
				res = true
			}
			else {
				res = false
			}
			selectFunc((tableCell?.textLabel?.text)!, res)
			tableView.reloadRows(at: [IndexPath(row: 0, section: 0), indexPath], with: .automatic)
		}
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
