//
//  AboutScreenViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 7/28/17.
//  Copyright © 2017 SRCT. All rights reserved.
//

import UIKit

class AboutScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var versionLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
		let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
		
		let versionstring = "Version " + version + " (" + build + ")"
		
		versionLabel.text = versionstring
		
		
		
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
		"Jason Yeomans"
	]
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contributors.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Thanks to the contributors to What's Open!"
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Contributor", for: indexPath)
		
		cell.textLabel!.text = contributors[indexPath.row]
		
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
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
