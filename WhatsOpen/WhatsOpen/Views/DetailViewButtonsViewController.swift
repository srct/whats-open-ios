//
//  DetailViewButtonsViewController.swift
//  WhatsOpen
//
//  Created by Zach Knox on 4/16/18.
//  Copyright © 2018 SRCT. All rights reserved.
//

import UIKit
import MapKit

class DetailViewButtonsViewController: UIViewController {

	@IBOutlet var facilityDetailView: UIView!
	var detailViewController: FacilityDetailViewController?
	var facility: Facility!
	
	@IBOutlet var favoritesButton: UIButton!
	@IBOutlet var directionsButton: UIButton!
	@IBOutlet var shareButton: UIButton!
	
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
		let appToUse = UserDefaults.standard.value(forKey: "mapsApp") as? String
		
		if appToUse == "Google Maps" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			if let url = URL(string: "comgooglemaps://?q=\((facility.facilityLocation?.coordinates?.coords?.last)!)),\((facility.facilityLocation?.coordinates?.coords?.first)!)") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		else if appToUse == "Waze" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			if let url = URL(string: "https://waze.com/ul?ll=\((facility.facilityLocation?.coordinates?.coords?.last)!)),\((facility.facilityLocation?.coordinates?.coords?.first)!))") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		else {
			let regionDistance:CLLocationDistance = 100
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
	}
	
	
	@IBAction func shareFacility(_ sender: Any) {
		let str = "\(facility.facilityName) is \(Utilities.openOrClosedUntil(facility)!.lowercased())"
		let shareSheet = UIActivityViewController(activityItems: ["\(str) https://whatsopen.gmu.edu/"], applicationActivities: nil)
		shareSheet.excludedActivityTypes = [.print, .openInIBooks, .addToReadingList] // Sorry you can't print a Facility
		present(shareSheet, animated: true, completion: nil)
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
	
	override func viewDidLoad() {
		// Dealing with container views and subviews
		// https://spin.atomicobject.com/2015/10/13/switching-child-view-controllers-ios-auto-layout/
		self.detailViewController!.view.translatesAutoresizingMaskIntoConstraints = false
		self.addChildViewController(self.detailViewController!)
		self.addSubview(self.detailViewController!.view, toView: self.facilityDetailView)
        super.viewDidLoad()

		setFavoriteButtonText()
		favoritesButton.tintColor = UIColor.white
		favoritesButton.backgroundColor = UIColor(red:0.00, green:0.40, blue:0.20, alpha:1.0)
		favoritesButton.layer.cornerRadius = 10
		directionsButton.tintColor = UIColor.white
		directionsButton.backgroundColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
		directionsButton.layer.cornerRadius = 10
		
		let appToUse = UserDefaults.standard.value(forKey: "mapsApp") as? String
		if appToUse == "Google Maps" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			directionsButton.setTitle("View in Google Maps", for: .normal)
		}
		else if appToUse == "Waze" && UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
			directionsButton.setTitle("View in Waze", for: .normal)
		}
		else {
			directionsButton.setTitle("View in Maps", for: .normal)
		}
		shareButton.tintColor = UIColor.white
		shareButton.backgroundColor = UIColor.orange
		shareButton.layer.cornerRadius = 10
		shareButton.setImage(#imageLiteral(resourceName: "shareIcon"), for: .normal)
		shareButton.setTitle("", for: .normal)

		
        // Do any additional setup after loading the view.
    }
	
	func addSubview(_ subView: UIView, toView parentView: UIView) {
		parentView.addSubview(subView)
		
		var viewBindingsDict = [String: AnyObject]()
		viewBindingsDict["subView"] = subView
		parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
																 options: [], metrics: nil, views: viewBindingsDict))
		parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
																 options: [], metrics: nil, views: viewBindingsDict))
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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