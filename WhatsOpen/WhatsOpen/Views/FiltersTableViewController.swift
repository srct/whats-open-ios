//
//  FiltersTableViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/26/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit
import RealmSwift

class FiltersTableViewController: UITableViewController {

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
	@IBAction func doneButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func resetButton(_ sender: Any) {
		filters = Filters()
		tableView.reloadData()
	}
	var filters: Filters!
	var facilities: List<Facility>!
	//var allLocations: [Locations] = [Locations]()
	//var allCategories: [Categories]! = [Categories]()
	
	var showOpen, showClosed, openFirst: SwitchingTableViewCell!
	var sortOptions: [CheckingTableViewCell] = []
	var onlyOne: OnlyOneChecked!
	
	override func viewWillAppear(_ animated: Bool) {
		onlyOne = OnlyOneChecked(tableView: self, tableCellChecked: -1)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		/*
		for f in facilities {
			if(!allLocations.contains(f.facilityLocation!)) {
				allLocations.append(f.facilityLocation!)
			}
			if(!allCategories.contains(f.category!)) {
				allCategories.append(f.category!)
			}
		}
		*/
		
		tableView.reloadData()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		switch section {
		case 0:
			return 2
		case 1:
			return 1
		case 2:
			return SortMethod.count
		case 3:
			return 2
		default:
			return 0
		}
    }

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0, 1:
			return nil
		case 2:
			return "Sort Facilities"
		case 3:
			return "Show Only Specified"
		default:
			return nil
		}
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		  case 0:
			let cell: SwitchingTableViewCell
			switch indexPath.row {
			  case 0:
				cell = tableView.dequeueReusableCell(withIdentifier: "Switching", for: indexPath) as! SwitchingTableViewCell
				cell.textLabel!.text = "Show Open Locations"
				cell.switchControl.isOn = filters.showOpen
				cell.toggleFunc = updateOpenFirstEnabledState
				//self.showOpen = cell
			  case 1:
				cell = tableView.dequeueReusableCell(withIdentifier: "Switching", for: indexPath) as! SwitchingTableViewCell
				cell.textLabel!.text = "Show Closed Locations"
				cell.switchControl.isOn = filters.showClosed
				cell.toggleFunc = filters.setShowClosed
				//self.showClosed = cell
			  default:
				cell = UITableViewCell() as! SwitchingTableViewCell //this is bad don't let this happen
			}
			return cell
		  case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "Switching", for: indexPath) as! SwitchingTableViewCell
			cell.textLabel!.text = "Show Open Facilities First"
			cell.switchControl.isEnabled = filters.showOpen
			cell.switchControl.isOn = filters.openFirst
			cell.toggleFunc = filters.setOpenFirst
			return cell
		  case 2: // TODO
			let method: SortMethod
			let cellText: String
			switch indexPath.row {
			case 0:
				method = SortMethod.alphabetical
				cellText = "Alphabetically (A-Z)"
			case 1:
				method = SortMethod.reverseAlphabetical
				cellText = "Reverse Alphabetically (Z-A)"
			case 2:
				method = SortMethod.byLocation
				cellText = "By Location Name (A-Z)"
			default:
				method = SortMethod.alphabetical
				cellText = "Alphabetically (A-Z)"
			}
			let cell: CheckingTableViewCell
			cell = tableView.dequeueReusableCell(withIdentifier: "Checkbox Filter", for: indexPath) as! CheckingTableViewCell
			cell.onlyOne = self.onlyOne
			cell.cellIndex = indexPath.row
			cell.selectingEnum = method
			cell.selectFunc = onlyCheckOne
			if(filters.sortBy == method) {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
			cell.textLabel!.text = cellText
			sortOptions.append(cell)
			return cell
		  case 3: // TODO
			let cell = tableView.dequeueReusableCell(withIdentifier: "toSelection", for: indexPath)
			cell.accessoryType = .disclosureIndicator
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = "Categories"
				var i = 0
				for c in filters.onlyFromCategories {
					if(c.value == true) {
						i += 1
					}
				}
				var detail: String
				if(i == filters.onlyFromCategories.count) {
					detail = "All Selected"
				}
				else {
					detail = "\(i) Selected"
				}
			case 1:
				cell.textLabel?.text = "Locations"
				var i = 0
				for c in filters.onlyFromLocations {
					if(c.value == true) {
						i += 1
					}
				}
				var detail: String
				if(i == filters.onlyFromLocations.count) {
					detail = "All Selected"
				}
				else {
					detail = "\(i) Selected"
				}
			default:
				return cell
			}
			return cell
		  default:
			let cell = UITableViewCell() //this is bad don't let this happen
			return cell
		}

		return UITableViewCell() //shouldn't come to this
        // Configure the cell...
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.isSelected = false
		
		//nothing is selected forever
	}
	
	func updateOpenFirstEnabledState(_ to: Bool) -> Bool {
		filters.setShowOpen(to)
		let index = IndexPath(row: 0, section: 1)
		tableView.reloadRows(at: [index], with: .automatic)
		return true
	}
	
	func onlyCheckOne(_ method: Any?) -> Bool {
		filters.sortBy = method as! SortMethod // Be careful when calling this
		tableView.reloadData()
		return true
	}
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
		
		//Using this code means there won't be live updates, but that only matters on the iPad with a popover
		//filters.showOpen = showOpen.switchControl.isOn
		//filters.showClosed = showClosed.switchControl.isOn
		
		if(segue.identifier == "toFilters") {
			let destination = segue.destination as! FacilitiesListViewController
			destination.filters = self.filters
		}
		else if(segue.identifier == "toSelection") {
			let destination = segue.destination as! FilterSelectionTableViewController
			destination.navigationItem.title = (sender as! UITableViewCell).textLabel?.text!
			
			func get() -> [String: Bool] {
				if((sender as! UITableViewCell).textLabel?.text! == "Categories") {
					return filters.onlyFromCategories
				}
				else {
					return filters.onlyFromLocations
				}
			}
			func selectFunc(_ key: String, value: Bool) -> Bool {
				if((sender as! UITableViewCell).textLabel?.text! == "Categories") {
					filters.onlyFromCategories[key] = value
				}
				else {
					filters.onlyFromLocations[key] = value
				}
				return true
			}
			func selectAllFunc() -> Bool {
				if((sender as! UITableViewCell).textLabel?.text! == "Categories") {
					for var v in filters.onlyFromCategories {
						v.value = true
					}
				}
				else {
					for var v in filters.onlyFromLocations {
						v.value = true
					}
				}
				return true
			}
			
			destination.getFunc = get
			destination.selectFunc = selectFunc
			destination.selectAllFunc = selectAllFunc
			
			
		}
		
        // Pass the selected object to the new view controller.
    }

}
