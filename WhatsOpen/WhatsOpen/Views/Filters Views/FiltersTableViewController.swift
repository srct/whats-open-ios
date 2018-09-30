//
//  FiltersTableViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/26/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit
import RealmSwift
import WhatsOpenKit

class FiltersTableViewController: UITableViewController {

    var updateFacilities: (() -> Void)!
    
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
	@IBAction func doneButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func resetButton(_ sender: Any) {
		var c = filters.onlyFromCategories
		var l = filters.onlyFromLocations
		for v in c {
			c.updateValue(true, forKey: v.key)
		}
		for v in l {
			l.updateValue(true, forKey: v.key)
		}
		filters.openFirst = true
		filters.showClosed = true
		filters.showOpen = true
		filters.sortBy = .alphabetical
		filters.onlyFromCategories = c
		filters.onlyFromLocations = l
		tableView.reloadData()
        updateFacilities()
	}
	var filters: WOKFilters!
	var facilities: List<WOKFacility>!
	//var allLocations: [Locations] = [Locations]()
	//var allCategories: [Categories]! = [Categories]()
	
	var showOpen, showClosed, openFirst: SwitchingTableViewCell!
	var sortOptions: [CheckingTableViewCell] = []
	var onlyOne: OnlyOneChecked!
	
	override func viewWillAppear(_ animated: Bool) {
		onlyOne = OnlyOneChecked(tableView: self, tableCellChecked: -1)
		tableView.reloadData()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
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
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateFacilities?()
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
			return WOKSortMethod.count
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
                cell.toggleFunc = { [unowned self] isOn in
                    let result = self.updateOpenFirstEnabledState(isOn)
                    self.updateFacilities()
                    return result
                }
				//self.showOpen = cell
			  case 1:
				cell = tableView.dequeueReusableCell(withIdentifier: "Switching", for: indexPath) as! SwitchingTableViewCell
				cell.textLabel!.text = "Show Closed Locations"
				cell.switchControl.isOn = filters.showClosed
                cell.toggleFunc = { [unowned self] isOn in
                    let result = self.filters.setShowClosed(isOn)
                    self.updateFacilities()
                    return result
                }
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
            cell.toggleFunc = { [unowned self] isOn in
                let result = self.filters.setOpenFirst(isOn)
                self.updateFacilities()
                return result
            }
			return cell
		  case 2:
			let method: WOKSortMethod
			let cellText: String
			switch indexPath.row {
			case 0:
				method = WOKSortMethod.alphabetical
				cellText = "Alphabetically (A-Z)"
			case 1:
				method = WOKSortMethod.reverseAlphabetical
				cellText = "Reverse Alphabetically (Z-A)"
			case 2:
				method = WOKSortMethod.byLocation
				cellText = "By Location Name (A-Z)"
			default:
				method = WOKSortMethod.alphabetical
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
		  case 3:
			let cell = tableView.dequeueReusableCell(withIdentifier: "toSelection", for: indexPath)
			cell.accessoryType = .disclosureIndicator
			cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
			cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
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
				cell.detailTextLabel?.text = detail
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
				cell.detailTextLabel?.text = detail
			default:
				return cell
			}
			return cell
		  default:
			let cell = UITableViewCell() //this is bad don't let this happen
			return cell
		}

		//return UITableViewCell() //shouldn't come to this
        // Configure the cell...
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.isSelected = false
		
        updateFacilities()
		//nothing is selected forever
	}
	
	func updateOpenFirstEnabledState(_ to: Bool) -> Bool {
		_ = filters.setShowOpen(to)
		let index = IndexPath(row: 0, section: 1)
		tableView.reloadRows(at: [index], with: .automatic)
		return true
	}
	
	func onlyCheckOne(_ method: Any?) -> Bool {
		filters.sortBy = method as! WOKSortMethod // Be careful when calling this
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
            updateFacilities()
		}
		else if(segue.identifier == "toSelection") {
			let destination = segue.destination as! FilterSelectionTableViewController
			destination.navigationItem.title = (sender as! UITableViewCell).textLabel?.text!
			destination.updateFacilities = updateFacilities
			
			func get() -> [String: Bool] {
				if((sender as! UITableViewCell).textLabel?.text! == "Categories") {
					return filters.onlyFromCategories
				}
				else if(sender as! UITableViewCell).textLabel?.text! == "Alerts" {
					return filters.showAlerts
				}
				else if(sender as! UITableViewCell).textLabel?.text! == "Campuses" {
					return filters.onlyFromCampuses
				}
				else {
					return filters.onlyFromLocations
				}
			}
			func selectFunc(_ key: String, value: Bool) -> Bool {
				if((sender as! UITableViewCell).textLabel?.text! == "Categories") {
					filters.onlyFromCategories[key] = value
				}
				else if(sender as! UITableViewCell).textLabel?.text! == "Alerts" {
					filters.showAlerts[key] = value
				}
				else if(sender as! UITableViewCell).textLabel?.text! == "Campuses" {
					filters.onlyFromCampuses[key] = value
				}
				else {
					filters.onlyFromLocations[key] = value
				}
				return true
			}
			func selectAllFunc() -> Bool {
				if((sender as! UITableViewCell).textLabel?.text! == "Categories") {
					var foundFalse = false
					for v in filters.onlyFromCategories {
						if !foundFalse {
							if !v.value {
								foundFalse = true
								filters.onlyFromCategories.updateValue(true, forKey: v.key)
							}
						}
						else {
							filters.onlyFromCategories.updateValue(true, forKey: v.key)
						}
					}
					if !foundFalse {
						for v in filters.onlyFromCategories {
							filters.onlyFromCategories.updateValue(false, forKey: v.key)
						}
					}
				}
				else if((sender as! UITableViewCell).textLabel?.text! == "Alerts") {
					var foundFalse = false
					for v in filters.showAlerts {
						if !foundFalse {
							if !v.value {
								foundFalse = true
								filters.showAlerts.updateValue(true, forKey: v.key)
							}
						}
						else {
							filters.showAlerts.updateValue(true, forKey: v.key)
						}
					}
					if !foundFalse {
						for v in filters.showAlerts {
							filters.showAlerts.updateValue(false, forKey: v.key)
						}
					}
				}
				else if((sender as! UITableViewCell).textLabel?.text! == "Campuses") {
					var foundFalse = false
					for v in filters.onlyFromCampuses {
						if !foundFalse {
							if !v.value {
								foundFalse = true
								filters.onlyFromCampuses.updateValue(true, forKey: v.key)
							}
						}
						else {
							filters.onlyFromCampuses.updateValue(true, forKey: v.key)
						}
					}
					if !foundFalse {
						for v in filters.onlyFromCampuses {
							filters.onlyFromCampuses.updateValue(false, forKey: v.key)
						}
					}
				}
				else {
					var foundFalse = false
					for v in filters.onlyFromLocations {
						if !foundFalse {
							if !v.value {
								foundFalse = true
								filters.onlyFromLocations.updateValue(true, forKey: v.key)
							}
						}
						else {
							filters.onlyFromLocations.updateValue(true, forKey: v.key)
						}
					}
					if !foundFalse {
						for v in filters.onlyFromLocations {
							filters.onlyFromLocations.updateValue(false, forKey: v.key)
						}
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
