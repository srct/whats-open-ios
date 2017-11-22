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
    @IBOutlet var CategoryLabel: UILabel!
    
	@IBOutlet var OpenTimesList: UITableView!
	
	@IBOutlet var detailStackView: UIStackView!
	
	override var previewActionItems: [UIPreviewActionItem] {
		var title: String
		if(Utilities.isFavoriteFacility(facility)) {
			title = "Remove from Favorites"
		}
		else {
			title = "Add to Favorites"
		}
		let favoritePreviewItem = UIPreviewAction(title: title, style: UIPreviewActionStyle.default, handler: markAsFavoritePreviewAction)
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
		
		NameLabel.text = facility.facilityName
		PlaceLabel.text = facility.facilityLocation!.building
        CategoryLabel.text = facility.category?.categoryName.uppercased()

		
		let open = Utilities.isOpen(facility: facility)
        OpenLabel.text = Utilities.openOrClosedUntil(facility)
        OpenLabel.layer.cornerRadius = 4
        OpenLabel.layer.masksToBounds = true
		if(open) {
			OpenLabel.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		}
		else {
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
        if(Utilities.isSpecialSchedule(facility) == true) {
            return (facility.specialSchedule?.openTimes.count)!
        }
        else {
            return (facility.mainSchedule?.openTimes.count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OpenTimesList.dequeueReusableCell(withIdentifier: "LocationDetailCell", for: indexPath)

        if(Utilities.isSpecialSchedule(facility) == true) {
            let openTime = facility.specialSchedule?.openTimes[indexPath.row]
            cell.textLabel?.text = Utilities.getDayOfWeek(Day(rawValue: openTime!.startDay)!)
            cell.detailTextLabel?.text = Utilities.getFormattedStartandEnd(openTime!)
        }
        else {
            let openTime = facility.mainSchedule?.openTimes[indexPath.row]
            cell.textLabel?.text = Utilities.getDayOfWeek(Day(rawValue: openTime!.startDay)!)
            cell.detailTextLabel?.text = Utilities.getFormattedStartandEnd(openTime!)
        }


        // Configure the cell...

        return cell
    }
			
	func markAsFavoritePreviewAction(_ sendingAction: UIPreviewAction, sender: UIViewController) {
		if(Utilities.isFavoriteFacility(facility)) {
			Utilities.removeFavoriteFacility(facility)
		}
		else {
			Utilities.addFavoriteFacility(facility)
		}
	}
}
