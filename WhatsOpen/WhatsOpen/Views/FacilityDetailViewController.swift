//
//  LocationDetailViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit

class FacilityDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var NameLabel: UILabel!
	@IBOutlet var PlaceLabel: UILabel!
	@IBOutlet var OpenLabel: UILabel!

	@IBOutlet var OpenTimesList: UITableView!
	
	@IBOutlet var detailStackView: UIStackView!
	
	override var previewActionItems: [UIPreviewActionItem] {
		let favoritePreviewItem = UIPreviewAction(title: "Mark as Favorite", style: UIPreviewActionStyle.default, handler: markAsFavoritePreviewAction)
	    return [favoritePreviewItem]
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	var facility: Facility!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		
		modalPresentationCapturesStatusBarAppearance = true
		
		NameLabel.text = facility.name
		PlaceLabel.text = facility.location
		let open = Utilities.isOpen(facility: facility)
		if(open) {
			OpenLabel.text = "OPEN"
			OpenLabel.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		}
		else {
			OpenLabel.text = "CLOSED"
			OpenLabel.backgroundColor = UIColor.red
		}
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 7
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = OpenTimesList.dequeueReusableCell(withIdentifier: "LocationDetailCell", for: indexPath)
		
		
		// Configure the cell...
		
		return cell
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
			
	func markAsFavoritePreviewAction(_ sendingAction: UIPreviewAction, sender: UIViewController) {
		
	}
}
