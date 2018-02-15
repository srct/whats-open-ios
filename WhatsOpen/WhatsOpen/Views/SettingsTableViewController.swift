//
//  SettingsTableViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/25/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit
import SafariServices
import MessageUI
import StoreKit

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
	@IBAction func doneButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.estimatedRowHeight = 44.0
		tableView.rowHeight = UITableViewAutomaticDimension

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
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if(section == 0) {
			return 1
		}
		else if(section == 1) {
			return 1
		}
		else if(section == 2) {
			return 1
		}
		else if(section == 3) {
			return 3
		}
		else {
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! SettingTableViewCell
			cell.textLabel!.text = "Are Our Hours Wrong?"
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! SettingTableViewCell
			cell.textLabel!.text = "Select App Icon"
			cell.accessoryType = .disclosureIndicator
			return cell
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingSelection", for: indexPath)
			cell.accessoryType = .disclosureIndicator
			cell.textLabel?.text = "Show Alerts"
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body, compatibleWith: nil)
            cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote, compatibleWith: nil)
			
			/*
			let defaults = UserDefaults.standard
			let alertsFromDefaults = defaults.dictionary(forKey: "alerts")
			if alertsFromDefaults == nil {
				var setAlerts = [String: Bool]()
				setAlerts.updateValue(true, forKey: "Informational")
				setAlerts.updateValue(true, forKey: "Minor Alerts")
				setAlerts.updateValue(true, forKey: "Major Alerts")
				defaults.set(setAlerts, forKey: "alerts")
			}
			*/
			
			let alerts = Utilities.getAlertDefaults()
				var i = 0
			for c in alerts {
					if(c.value == true) {
						i += 1
					}
				}
				var detail: String
			if(i == alerts.count) {
					detail = "All Selected"
				}
				else {
					detail = "\(i) Selected"
				}
				cell.detailTextLabel?.text = detail
			return cell
		case 3:
			let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! SettingTableViewCell
			switch indexPath.row {
			case 0:
				cell.textLabel!.text = "Review on the App Store"
			case 1:
				cell.textLabel!.text = "About SRCT"
				cell.linkURL = URL(string: "https://srct.gmu.edu")
			case 2:
				cell.textLabel!.text = "About What's Open"
			default:
				cell.textLabel!.text = "rip"
			}
			return cell
		default:
			break
		}
        // Configure the cell...

        return tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! SettingTableViewCell // don't let this happen
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = self.tableView(tableView, cellForRowAt: indexPath)
		
		if let settingcell = cell as? SettingTableViewCell {
			// Eventually we should change this logic to make it not reliant on English text
			if settingcell.linkURL != nil {
				self.showDetailViewController(SFSafariViewController(url: settingcell.linkURL!), sender: settingcell)
			}
			else if settingcell.textLabel!.text == "Are Our Hours Wrong?" {
				let mailvc = initMail(subject: "What's Open - Your Hours are Wrong", to: "srct@gmu.edu")
				if !MFMailComposeViewController.canSendMail() {
					/*
					let alert = UIAlertController(title: "Mail Not Available", message: "Make sure your mail account is properly set up.", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
						NSLog("The \"OK\" alert occured.")
					}))
					present(alert, animated: true)
					*/
					// Do literally nothing
				}
				else {
					present(mailvc, animated: true)
				}
			}
			else if settingcell.textLabel?.text == "Select App Icon" {
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "setAppIcon")
				self.show(vc!, sender: settingcell)
			}
			else if settingcell.textLabel?.text == "Review on the App Store" {
				let appId = "1331260366"
				
				let urlString = "itms-apps://itunes.apple.com/us/app/whats-open-at-mason/id\(appId)?action=write-review"
				
				if let url = URL(string: urlString) {
					UIApplication.shared.open((url), options: [:], completionHandler: nil)
				}
			}
			else if settingcell.textLabel!.text == "About What's Open" {
				let avc = self.storyboard?.instantiateViewController(withIdentifier: "about")
				self.show(avc!, sender: settingcell)
			}
		}
		else {
			return
		}
	}
	
	func initMail(subject: String, to: String) -> MFMailComposeViewController {
		let mailto = MFMailComposeViewController()
		mailto.mailComposeDelegate = self
		mailto.setSubject(subject)
		mailto.setToRecipients([to])
		let df = DateFormatter()
		let now = Date()
		mailto.setMessageBody("\n\n"+df.string(from: now), isHTML: false)
		return mailto
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController,
							   didFinishWith result: MFMailComposeResult, error: Error?) {
		// Check the result or perform other tasks.
		
		// Dismiss the mail compose view controller.
		controller.dismiss(animated: true, completion: nil)
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
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "settingSelection" {
			let destination = segue.destination as! FilterSelectionTableViewController
			destination.navigationItem.title = "Show Alerts"
			destination.getFunc = Utilities.getAlertDefaults
			destination.selectFunc = Utilities.setAlertDefaults
			destination.selectAllFunc = Utilities.setAllAlertDefaults
		}
    }
	

}
