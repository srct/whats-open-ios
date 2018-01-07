//
//  SetIconTableViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 1/7/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit

class SetIconTableViewController: UITableViewController {

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
        return 5
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! IconSelectionTableViewCell

        // Configure the cell...
		switch indexPath.row {
		case 0:
			cell.iconThumbnail.image = #imageLiteral(resourceName: "appicon-76.png")
			cell.iconName.text = "Default"
			if UIApplication.shared.alternateIconName == nil {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
		case 1:
			cell.iconThumbnail.image = #imageLiteral(resourceName: "iosicon-srctlogo-76.png")
			cell.iconName.text = "SRCT Logo"
			if UIApplication.shared.alternateIconName == "iosicon-srct" {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
		case 2:
			cell.iconThumbnail.image = #imageLiteral(resourceName: "iosicon-1009-76.png")
			cell.iconName.text = "Morning"
			if UIApplication.shared.alternateIconName == "iosicon-1009" {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
		case 3:
			cell.iconThumbnail.image = #imageLiteral(resourceName: "iosicon-420-76.png")
			cell.iconName.text = "Afternoon"
			if UIApplication.shared.alternateIconName == "iosicon-420" {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
		case 4:
			cell.iconThumbnail.image = #imageLiteral(resourceName: "iosicon-730-76.png")
			cell.iconName.text = "Meeting Time"
			if UIApplication.shared.alternateIconName == "iosicon-730" {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
		default:
			cell.iconThumbnail.image = #imageLiteral(resourceName: "appicon-76.png")
			cell.iconName.text = "Default"
			if UIApplication.shared.alternateIconName == nil {
				cell.accessoryType = .checkmark
			}
			else {
				cell.accessoryType = .none
			}
		}
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			UIApplication.shared.setAlternateIconName(nil) { (error) in
				if let error = error {
					print("err: \(error)")
				}
			}
		case 1:
			UIApplication.shared.setAlternateIconName("iosicon-srct") { (error) in
				if let error = error {
					print("err: \(error)")
				}
			}
		case 2:
			UIApplication.shared.setAlternateIconName("iosicon-1009") { (error) in
				if let error = error {
					print("err: \(error)")
				}
			}
		case 3:
			UIApplication.shared.setAlternateIconName("iosicon-420") { (error) in
				if let error = error {
					print("err: \(error)")
				}
			}
		case 4:
			UIApplication.shared.setAlternateIconName("iosicon-730") { (error) in
				if let error = error {
					print("err: \(error)")
				}
			}
		default:
			UIApplication.shared.setAlternateIconName(nil) { (error) in
				if let error = error {
					print("err: \(error)")
				}
			}
		}
		tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
