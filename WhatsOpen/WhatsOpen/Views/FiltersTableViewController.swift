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
	
	var filters: Filters!
	var facilities: List<Facility>!
	var allLocations: [Locations] = [Locations]()
	var allCategories: [Categories]! = [Categories]()
	
	var showOpen, showClosed, openFirst: SwitchingTableViewCell!
	var sortOptions: [CheckingTableViewCell] = []
	var onlyOne: OnlyOneChecked!
	
	override func viewWillAppear(_ animated: Bool) {
		onlyOne = OnlyOneChecked(tableView: self, tableCellChecked: -1)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		for f in facilities {
			if(!allLocations.contains(f.facilityLocation!)) {
				allLocations.append(f.facilityLocation!)
			}
			if(!allCategories.contains(f.category!)) {
				allCategories.append(f.category!)
			}
		}
		
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
        return 5
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
			return 1
		case 4:
			return 1
		default:
			return 0
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
		  case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "Switching", for: indexPath) as! SwitchingTableViewCell
			cell.textLabel!.text = "Show Open Facilities First"
			cell.switchControl.isEnabled = filters.showOpen
			cell.toggleFunc = filters.setOpenFirst
		  case 2: // TODO
			let cell: CheckingTableViewCell
			cell = tableView.dequeueReusableCell(withIdentifier: "Checkbox Filter", for: indexPath) as! CheckingTableViewCell
			cell.onlyOne = self.onlyOne
			cell.cellIndex = indexPath.row
			sortOptions.append(cell)
			return cell
		  case 3: // TODO
			let cell = tableView.dequeueReusableCell(withIdentifier: "picking", for: indexPath) as! PickingTableViewCell
			cell.pickerStrings = []
			cell.pickerItems = []
			
			return cell
		  case 4: // TODO
			let cell = tableView.dequeueReusableCell(withIdentifier: "picking", for: indexPath) as! PickingTableViewCell
			cell.pickerStrings = []
			cell.pickerItems = []
			
			return cell
		  default:
			let cell = UITableViewCell() //this is bad don't let this happen
			return cell
		}

		return UITableViewCell() //shouldn't come to this
        // Configure the cell...
    }
	
	func updateOpenFirstEnabledState(_ to: Bool) -> Bool {
		filters.setShowOpen(to)
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
		filters.showOpen = showOpen.switchControl.isOn
		filters.showClosed = showClosed.switchControl.isOn
		
		if(segue.identifier == "toFilters") {
			let destination = segue.destination as! FacilitiesListViewController
			destination.filters = self.filters
		}
		
        // Pass the selected object to the new view controller.
    }

}
