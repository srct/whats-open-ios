//
//  AboutScreenViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 7/28/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit
import SafariServices
import WhatsOpenKit

class AboutScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var versionLabel: UILabel!
	@IBOutlet var aboutLogo: UIImageView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}
	
	@objc func pickAPIURL(_ sender: Any?) {
		let alert = UIAlertController(title: "Set API Endpoint URL?", message: "", preferredStyle: .alert)
		alert.addTextField { textField in
			textField.text = WOPDatabaseController.getDefaults().string(forKey: "apiURL") ?? ""
		}
		alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (action) in
			WOPDatabaseController.getDefaults().set("https://api.srct.gmu.edu/whatsopen/v2/", forKey: "apiURL")
			
			alert.dismiss(animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { (action) in
			WOPDatabaseController.getDefaults().set(alert.textFields![0].text, forKey: "apiURL")
		}))
		
		present(alert, animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
		let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
		
		let versionstring = "Version " + version + " (" + build + ")"
		
		versionLabel.text = versionstring
		
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pickAPIURL(_:)))
		aboutLogo.isUserInteractionEnabled = true
		aboutLogo.addGestureRecognizer(longPress)
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	let contributors = [
		"Eyad Hasan",
		"Zach Knox",
		"Patrick Murray",
        "Jesse Scearce",
		"Zac Wood",
		"Jason Yeomans"
	]
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return contributors.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "What's Open for iOS is an open source project created by students at George Mason University"
		case 1:
			return "Thanks to the contributors to What's Open!"
		default:
			return ""
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if let headerView = view as? UITableViewHeaderFooterView {
			switch section {
			case 0:
				headerView.textLabel?.text = "What's Open for iOS is an open source project created by students at George Mason University"
			case 1:
				headerView.textLabel?.text = "Thanks to the contributors to What's Open!"
			default:
				headerView.textLabel?.text = ""
			}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Contributor", for: indexPath) as! SettingTableViewCell
		
		switch indexPath.section {
		case 0:
			cell.textLabel!.text = "Check out our code on Gitlab"
			cell.selectionStyle = UITableViewCell.SelectionStyle.blue
			cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
		case 1:
			cell.textLabel!.text = contributors[indexPath.row]
		default:
			break
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			let cell = self.tableView(tableView, cellForRowAt: indexPath) as! SettingTableViewCell
			let lnk = URL(string: "https://git.gmu.edu/srct/whats-open-ios")
			self.showDetailViewController(SFSafariViewController(url: lnk!), sender: cell)
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
