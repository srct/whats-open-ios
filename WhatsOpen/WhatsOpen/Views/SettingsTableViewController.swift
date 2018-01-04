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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if(section == 0) {
			return 1
		}
		else if(section == 1) {
			return 3
		}
		else {
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as! SettingTableViewCell

		switch indexPath.section {
		case 0:
			cell.textLabel!.text = "Are Our Hours Wrong?"
		case 1:
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
			if indexPath.row == 0 {

			}
			else if indexPath.row == 1 {

			}
		default:
			break
		}
        // Configure the cell...

        return cell
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
			else if settingcell.textLabel?.text == "Review on the App Store" {
				let appPage = SKStoreProductViewController()
				let params = [SKStoreProductParameterITunesItemIdentifier: 1331260366]
				appPage.loadProduct(withParameters: params, completionBlock: { (result, err) in
					if err == nil && result == true {
						self.present(appPage, animated: true)
						print("presenting")
					}
					else {
						let alert = UIAlertController(title: "Cound Not Find App in Store", message: "Check your network connection", preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
						}))
						self.present(alert, animated: true)
						print("alerting")
					}
				})
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
