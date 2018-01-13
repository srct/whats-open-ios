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
    @IBOutlet var favoritesButton: UIButton!
    
    var facility: Facility!
	
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
	
    /**
     Favorites button touch handler
     
     Adds a facility to favorites if it isn't a favorite,
     removes from favorites if it is a favorite.
     */
	@IBAction func setFavButton(_ sender: Any) {
        if(Utilities.isFavoriteFacility(facility)) { // if the facility is a favorite
			Utilities.removeFavoriteFacility(facility) // remove it from favorites
		}
		else { // else add it to favorites
			Utilities.addFavoriteFacility(facility)
		}
		setFavoriteButtonText()
	}
    
    /**
     Change the favorite button text depending on if the facility is a favorite
     */
	func setFavoriteButtonText() {
		if(Utilities.isFavoriteFacility(facility)) {
			favoritesButton.setTitle("Remove from Favorites", for: .normal)
			favoritesButton.titleLabel?.text = "Remove from Favorites"
		}
		else {
			favoritesButton.setTitle("Add to Favorites", for: .normal)
			favoritesButton.titleLabel?.text = "Add to Favorites"
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
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
			OpenLabel.backgroundColor = UIColor(red:0.17, green:0.17, blue: 0.17, alpha: 1.0)
		}
		
		setFavoriteButtonText()
		favoritesButton.tintColor = UIColor.white
		favoritesButton.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		favoritesButton.layer.cornerRadius = 10

		OpenTimesList.bounces = false
		
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

		cell.selectionStyle = .none
		
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
