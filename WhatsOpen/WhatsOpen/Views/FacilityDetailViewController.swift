//
//  LocationDetailViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/5/17.
//  Copyright © 2017 SRCT. Some rights reserved.
//

import UIKit
import StoreKit
import MapKit

class FacilityDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet var NameLabel: UILabel!
	@IBOutlet var PlaceLabel: UILabel!
	@IBOutlet var OpenLabel: UILabel!
    @IBOutlet var CategoryLabel: UILabel!
	@IBOutlet var OpenTimesList: UITableView!
    @IBOutlet var favoritesButton: UIButton!
	@IBOutlet var directionsButton: UIButton!
	@IBOutlet var shareButton: UIButton!
	
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
			_ = Utilities.removeFavoriteFacility(facility) // remove it from favorites
		}
		else { // else add it to favorites
			_ = Utilities.addFavoriteFacility(facility)
		}
		setFavoriteButtonText()
	}
    
	@IBAction func getDirections(_ sender: Any) {
		let regionDistance:CLLocationDistance = 100
		print("Lat: \(String(describing: facility.facilityLocation?.coordinates?.coords?.first)) Long: \(String(describing: facility.facilityLocation?.coordinates?.coords?.last))")
		let coordinates = CLLocationCoordinate2DMake((facility.facilityLocation?.coordinates?.coords?.last)!, (facility.facilityLocation?.coordinates?.coords?.first)!)
		dump(coordinates)
		let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
		let options = [
			MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
			MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
		]
		let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = facility.facilityName
		mapItem.openInMaps(launchOptions: options)
	}
	
	
	@IBAction func shareFacility(_ sender: Any) {
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
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(true)
		// MARK - Begging for App Reviews
		let prompt = UserDefaults.standard.integer(forKey: "reviewPrompt")
		if(arc4random_uniform(100) > 85 && prompt >= 4) {
			SKStoreReviewController.requestReview()
			UserDefaults.standard.set(0, forKey: "reviewPrompt")
		}
		else {
			UserDefaults.standard.set(prompt + 1, forKey: "reviewPrompt")
		}
		
	}
    override func viewDidLoad() {
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
		directionsButton.tintColor = UIColor.white
		directionsButton.backgroundColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
		directionsButton.layer.cornerRadius = 10
		directionsButton.setTitle("View in Maps", for: .normal)

		OpenTimesList.bounces = false
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
        
//        NameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        PlaceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
//        OpenLabel.font = UIFont.preferredFont(forTextStyle: .body)
//        favoritesButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
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
		return Utilities.getCurrentSchedule(facility)!.openTimes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OpenTimesList.dequeueReusableCell(withIdentifier: "LocationDetailCell", for: indexPath)

		cell.selectionStyle = .none
		
		let schedule = Utilities.getCurrentSchedule(facility)
		let openTime = schedule!.openTimes[indexPath.row]
		cell.textLabel?.text = Utilities.getDayOfWeek(Day(rawValue: openTime.startDay)!)
		cell.detailTextLabel?.text = Utilities.getFormattedStartandEnd(openTime)

        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)

        return cell
    }
			
	func markAsFavoritePreviewAction(_ sendingAction: UIPreviewAction, sender: UIViewController) {
		if(Utilities.isFavoriteFacility(facility)) {
			_ = Utilities.removeFavoriteFacility(facility)
		}
		else {
			_ = Utilities.addFavoriteFacility(facility)
		}
	}
}
