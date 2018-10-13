//
//  LocationDetailViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

#if os(iOS)
import UIKit
import StoreKit
import MapKit

public class WOPFacilityDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet public var NameLabel: UILabel!
	@IBOutlet public var PlaceLabel: UILabel!
	@IBOutlet public var OpenLabel: WOPPaddedUILabel!
    @IBOutlet public var CategoryLabel: UILabel!
	@IBOutlet public var OpenTimesList: UITableView!
	public let activity = NSUserActivity(activityType: "facility")

	
    public var facility: WOPFacility!
	
	override public var previewActionItems: [UIPreviewActionItem] {
		var title: String
		if(WOPUtilities.isFavoriteFacility(facility)) {
			title = "Remove from Favorites"
		}
		else {
			title = "Add to Favorites"
		}
		let favoritePreviewItem = UIPreviewAction(title: title, style: UIPreviewAction.Style.default, handler: markAsFavoritePreviewAction)
	    return [favoritePreviewItem]
	}
	

	
	override public var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override public func viewDidDisappear(_ animated: Bool) {
		activity.resignCurrent()
	}
	
	override public func viewDidLoad() {
        super.viewDidLoad()
		
		modalPresentationCapturesStatusBarAppearance = true
		
		var name = facility.facilityName
		let separator = name.index(of: "[")
		if separator != nil {
			name = String(name[..<separator!]).replacingOccurrences(of: "\\s+$",with: "", options: .regularExpression)
		}
		NameLabel.text = name
		PlaceLabel.text = facility.facilityLocation!.building
        CategoryLabel.text = facility.category?.categoryName.uppercased()

		
		let open = WOPUtilities.isOpen(facility: facility)
        OpenLabel.text = WOPUtilities.openOrClosedUntil(facility)
        OpenLabel.layer.cornerRadius = 4
        OpenLabel.layer.masksToBounds = true
		if(open) {
			OpenLabel.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		}
		else {
			OpenLabel.backgroundColor = UIColor(red:0.17, green:0.17, blue: 0.17, alpha: 1.0)
		}
		
		OpenTimesList.bounces = false
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
		
	  	OpenLabel.layer.cornerRadius = 16
	  	OpenLabel.layer.masksToBounds = true
		
		setActivityUp()
        
//        NameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        PlaceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
//        OpenLabel.font = UIFont.preferredFont(forTextStyle: .body)
//        favoritesButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
    }
	
	func setActivityUp() {
		activity.isEligibleForHandoff = true
		activity.isEligibleForSearch = true
		activity.addUserInfoEntries(from: ["facility": facility.facilityName])
		activity.title = facility.facilityName
		activity.keywords = Set<String>(arrayLiteral: facility.facilityName, facility.facilityLocation!.building)
		//activity.keywords = [facility.facilityName, facility.facilityLocation?.building]
		activity.webpageURL = URL(string: "https://whatsopen.gmu.edu/")
		
		activity.becomeCurrent()
	}

	override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return WOPUtilities.getCurrentSchedule(facility)!.openTimes.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OpenTimesList.dequeueReusableCell(withIdentifier: "LocationDetailCell", for: indexPath)

		cell.selectionStyle = .none
		
		let schedule = WOPUtilities.getCurrentSchedule(facility)
		let openTime = schedule!.openTimes[indexPath.row]
		cell.textLabel?.text = WOPUtilities.getDayOfWeek(WOPDay(rawValue: openTime.startDay)!)
		cell.detailTextLabel?.text = WOPUtilities.getFormattedStartandEnd(openTime)

        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)

        return cell
    }
			
	public func markAsFavoritePreviewAction(_ sendingAction: UIPreviewAction, sender: UIViewController) {
		if(WOPUtilities.isFavoriteFacility(facility)) {
			_ = WOPUtilities.removeFavoriteFacility(facility)
		}
		else {
			_ = WOPUtilities.addFavoriteFacility(facility)
		}
	}
}
#endif
