//
//  SelectOneDefaultTableViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/6/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit

class SelectOneDefaultTableViewController: UITableViewController {

	// Passing functions rather than direct objects to make this class reusable
	var options: [String]!
	var defaultKey: String!
	let defaults = UserDefaults.standard
	
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
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return options.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "thereCanOnlyBeOne", for: indexPath)
		
		cell.textLabel?.text = options[indexPath.row]
		if defaults.value(forKey: defaultKey) as! String == options[indexPath.row] {
			cell.accessoryType = .checkmark
		}
		else {
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if navigationItem.title == "Select Maps App" {
			return "The app selected here will be used when opening a map from a facility's detail page."
		}
		return nil
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		defaults.set(tableView.cellForRow(at: indexPath)?.textLabel?.text, forKey: defaultKey)
		tableView.reloadData()
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
